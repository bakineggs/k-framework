{-# LANGUAGE FlexibleContexts, Rank2Types #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Language.K
-- Copyright   :  (c) David Lazar, 2011
-- License     :  BSD3
--
-- Maintainer  :  lazar6@illinois.edu
-- Stability   :  experimental
-- Portability :  non-portable
--
-- A small, incomplete parser for low-level K.
-----------------------------------------------------------------------------

module Language.K where

import Control.Applicative ((<$>))
import Text.Parsec

import Internal.Lexer

-- | A nice type synonym to reduce clutter while still keeping things generic.
type GenParsecT a = (Stream s m Char) => ParsecT s u m a

-- | Parse a K term
kterm :: GenParsecT String
kterm = kempty <|> kapp

-- | Parse the K identity element
kempty :: GenParsecT String
kempty = string ".List{K}"

-- | Parse a K application: KLabel(K1,,K2)
kapp :: GenParsecT String
kapp = do
    (label, argc) <- klabel
    argv <- parens (kterm `sepBy` (symbol ",,"))
    proceed label argc argv
    where proceed label argc argv
              | argc == 0 = return label
              | argc /= length argv = fail "unexpected number of arguments"
              | otherwise = return $ label ++ " " ++ parenthesize argv

{- KLabels -}

-- | A KLabel is its name and its number of arguments
type KLabel = (String, Int)

-- | Parse a KLabel
klabel :: GenParsecT KLabel
klabel = genklabel <|> kbuiltin

-- | Parse generated K label: 'Foo___
genklabel :: GenParsecT KLabel
genklabel = do
    char '\''
    name <- maudeIdentifier
    argc <- length <$> many (char '_')
    return (name, argc)

-- | Parse a K builtin
kbuiltin :: GenParsecT KLabel
kbuiltin = flip (,) 0 <$> (kint <|> kstring)

-- | Parse an Int builtin: Int 42
kint :: GenParsecT String
kint = do
    symbol "Int"
    i <- integer
    return (show i)

-- | Parse a String builtin: String "hello"
kstring :: GenParsecT String
kstring = do
    symbol "String"
    s <- stringLiteral
    return (show s)

{- Maude identifiers -}

-- | Note that this does not capture all Maude identifiers since, for K, we
-- assume identifiers will not contain '_'  and that '`' will not be used to
-- escape spaces.
maudeIdentifier :: GenParsecT String
maudeIdentifier = many maudeIdChar

maudeIdChar :: GenParsecT Char
maudeIdChar = noneOf ("`_ " ++ maudeIdSpecialChars) <|> maudeIdEscape

maudeIdEscape :: GenParsecT Char
maudeIdEscape = char '`' >> oneOf maudeIdSpecialChars

-- | 3.1: The characters ‘{’, ‘}’, ‘(’, ‘)’, ‘[’, ‘]’ and ‘,’ are special, in
-- that they break a sequence of characters into several identifiers.
maudeIdSpecialChars :: String
maudeIdSpecialChars = "{}()[],"

{- Utilities -}

-- | ["x", "y", "z"] -> "(x) (y) (z)"
parenthesize :: [String] -> String
parenthesize = unwords . map (\x -> "(" ++ x ++ ")")

{- Test cases -}

test1 = parseTest kterm "'NegApp_('Lit_('Int_(Int 42(.List{K}))))"
test2 = parseTest kterm "'Let__('BDecls_('`(:`)__('FunBind_('`(:`)__('Match______('SrcLoc___(String \"unknown.hs\"(.List{K}),,Int 0(.List{K}),,Int 0(.List{K})),,'Ident_(String \"ok0\"(.List{K})),,'`(:`)__('PVar_('Ident_(String \"x\"(.List{K}))),,'`[`](.List{K})),,'Nothing(.List{K}),,'UnGuardedRhs_('Var_('UnQual_('Ident_(String \"foo\"(.List{K}))))),,'BDecls_('`[`](.List{K}))),,'`(:`)__('Match______('SrcLoc___(String \"unknown.hs\"(.List{K}),,Int 0(.List{K}),,Int 0(.List{K})),,'Ident_(String \"ok0\"(.List{K})),,'`(:`)__('PWildCard(.List{K}),,'`[`](.List{K})),,'Nothing(.List{K}),,'UnGuardedRhs_('App__('Var_('UnQual_('Ident_(String \"fail\"(.List{K})))),,'Lit_('String_(String \"pattern fail\"(.List{K}))))),,'BDecls_('`[`](.List{K}))),,'`[`](.List{K})))),,'`[`](.List{K}))),,'InfixApp___('Var_('UnQual_('Ident_(String \"xs\"(.List{K})))),,'QVarOp_('UnQual_('Symbol_(String \">>=\"(.List{K})))),,'Var_('UnQual_('Ident_(String \"ok0\"(.List{K}))))))"
