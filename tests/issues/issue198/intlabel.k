kmod INTLABEL is
    including K

    syntax K ::= Exp | Int | pgm

    syntax Exp ::= `Lit Literal
                 | foo

    syntax Literal ::= `Int Int

    macro Lit (Int I:Int) = foo

endkm
