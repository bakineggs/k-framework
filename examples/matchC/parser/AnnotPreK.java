import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.Token;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.tree.*;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.Stack;
import java.util.Iterator;


public class AnnotPreK {
  public static final HashMap<Integer, String>
    tokenToK = new HashMap<Integer, String>();
  public static final HashMap<Integer, String>
    tokenToBuiltins = new HashMap<Integer, String>();
  public static final HashSet<String>
    coreK = new HashSet<String>();
  public static final HashMap<String, String>
    tokenToWrapper = new HashMap<String, String>();

  public static void init() {
    coreK.add("_~>_");
    coreK.add("(.).K");
    coreK.add(".");

    tokenToK.put(annotParser.PRE, "@`pre_");
    tokenToK.put(annotParser.POST, "@`post_");
    tokenToK.put(annotParser.ASSUME, "@`assume_");
    tokenToK.put(annotParser.ASSERT, "@`assert_");
    tokenToK.put(annotParser.INVARIANT, "@`invariant_");
    tokenToK.put(annotParser.SKIP, "@`skip");
    tokenToK.put(annotParser.VERIFY, "@`verify");
    tokenToK.put(annotParser.BREAKPOINT, "@`breakpoint");
    tokenToBuiltins.put(annotParser.DISJ, "_\\/_");
    tokenToBuiltins.put(annotParser.CONJ, "_/\\_");
    tokenToBuiltins.put(annotParser.NEG, "~_");
    tokenToBuiltins.put(annotParser.EQ, "_===_");
    tokenToBuiltins.put(annotParser.LT, "_<Int_");
    tokenToBuiltins.put(annotParser.LEQ, "_<=Int_");
    tokenToBuiltins.put(annotParser.GT, "_>Int_");
    tokenToBuiltins.put(annotParser.GEQ, "_>=Int_");
    tokenToBuiltins.put(annotParser.UNION, "_U_");
    tokenToBuiltins.put(annotParser.APPEND, "_@_");
    tokenToBuiltins.put(annotParser.ADD, "_+Int_");
    tokenToBuiltins.put(annotParser.SUB, "_-Int_");
    tokenToBuiltins.put(annotParser.MUL, "_*Int_");
    tokenToBuiltins.put(annotParser.DIV, "_/Int_");
    tokenToBuiltins.put(annotParser.REM, "_%Int_");
    tokenToBuiltins.put(annotParser.SIGN_POS, "+Int_");
    tokenToBuiltins.put(annotParser.SIGN_NEG, "-Int_");
    tokenToBuiltins.put(annotParser.SEQ, "`[_`]");
    tokenToBuiltins.put(annotParser.MSET, "`{|_|`}");
    tokenToBuiltins.put(annotParser.MAPSTO, "_|->_");
    tokenToBuiltins.put(annotParser.POINTSTO, "_|->_:_");
    tokenToBuiltins.put(annotParser.HEAP_PATTERN, "_`(_`)`(_`)");
    tokenToBuiltins.put(annotParser.CELL, "<_>_</_>");
    tokenToBuiltins.put(annotParser.FORMULA_TRUE, "TrueFormula");
    tokenToBuiltins.put(annotParser.FORMULA_FALSE, "FalseFormula");
    tokenToBuiltins.put(kernelCParser.ID, "id`(_`)");
  }

  public static String annotToMaudeString(String annotString) {
    init();

    try {
      // Parsing
      InputStream is = new ByteArrayInputStream(annotString.getBytes("UTF-8"));
      ANTLRInputStream input = new ANTLRInputStream(is);
      annotLexer lexer = new annotLexer(input);
      CommonTokenStream tokens = new CommonTokenStream(lexer);
      annotParser parser = new annotParser(tokens);
      CommonTree tree = (CommonTree) parser.annot().getTree();

      // Rewriting the AST
      CommonTreeNodeStream nodes;

      completeConfig(tree);

      nodes = new CommonTreeNodeStream(tree);
      annotPass1 pass1 = new annotPass1(nodes);
      tree = (CommonTree) pass1.downup(tree);

      nodes = new CommonTreeNodeStream(tree);
      annotPass2 pass2 = new annotPass2(nodes);
      tree = (CommonTree) pass2.downup(tree);

      // Replace operators with K
      TreeUtils.makeOps(tree, tokenToK, tokenToBuiltins);

      nodes = new CommonTreeNodeStream(tree);
      annotPass3 pass3 = new annotPass3(nodes);
      tree = (CommonTree) pass3.downup(tree);

      // Make KLabels
      tree = (CommonTree) TreeUtils.makeLabels(tree, coreK, tokenToWrapper);

      // Unflat containers
      tree = (CommonTree) TreeUtils.unflat(tree, annotParser.LIST, annotParser.LIST, annotParser.LIST, "__", "(.).List");
      tree = (CommonTree) TreeUtils.unflat(tree, annotParser.MAP, annotParser.MAP, annotParser.MAP, "__", "(.).Map");
      tree = (CommonTree) TreeUtils.unflat(tree, annotParser.BAG, annotParser.BAG, annotParser.BAG, "__", "(.).Bag");
      tree = (CommonTree) TreeUtils.unflat(tree, k.K_LIST, k.K_LIST_COMMA, k.K_LIST_UNIT, "_`,`,_", ".List{K}");
      tree = (CommonTree) TreeUtils.unflat(tree, annotParser.MATH_OBJ_LIST, annotParser.MATH_OBJ_LIST, annotParser.MATH_OBJ_LIST, "_`,_", ".List{MathObj++}");

      CommonTree maudifiedTree = tree;

      //System.out.println(TreeUtils.toTreeString(maudifiedTree, 0));
      //System.out.println(TreeUtils.toMaudeString(tree));
      return TreeUtils.toMaudeString(maudifiedTree);
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (RecognitionException e) {
      e.printStackTrace();
    }

    return "";
  }

  public static void addCell(CommonTree cellBag, Table.Cell cell) {
    Token t;
    String cellLabel = cell.label;

    t = new CommonToken(annotParser.CELL, "CELL");
    CommonTree newCell = new CommonTree(t);
    cellBag.addChild(newCell);

    t = new CommonToken(annotParser.LABEL, cellLabel);
    newCell.addChild(new CommonTree(t));

    t = new CommonToken(annotParser.BAG, "BAG");
    CommonTree newBag = new CommonTree(t);
    newCell.addChild(newBag);

    if (cell.cells.isEmpty()) {
      String wrapper;
      if (!cell.isDefault) 
        wrapper = prefix + cell.sort + "Item";
      else
        wrapper = "default" + cell.sort + "Item";

      t = new CommonToken(annotParser.IDENTIFIER, wrapper);
      CommonTree newVar = new CommonTree(t);
      newBag.addChild(newVar);

      String wrappee;
      if (!cell.isDefault)
        wrappee = "\"" + suffix + "_" + cellLabel + "\"";
      else 
        wrappee = "\"" + cellLabel + "\"";

      t = new CommonToken(annotParser.IDENTIFIER, wrappee);
      newVar.addChild(new CommonTree(t));
    }

    t = new CommonToken(annotParser.LABEL, cellLabel);
    newCell.addChild(new CommonTree(t));
  }

  public static String prefix = "";
  public static String suffix = "";
  public static final Stack<String> prefixStack = new Stack<String>();
  public static final Stack<String> suffixStack = new Stack<String>();
  public static final Set<Table.Cell> cells = new HashSet<Table.Cell>();

  public static void completeConfig(CommonTree tree) {
    CommonTree cellBag = null;
    if (tree.getType() == annotParser.CONFIG) {
      cells.clear();
      cells.add(Table.Cell.CONFIG);
      cellBag = (CommonTree) tree.getChild(0);

      if (Table.varString.startsWith("?") || Table.varString.startsWith("!")) {
        prefix = Table.varString.substring(0, 1);
        suffix = Table.varString.substring(1);
      }
      else {
        prefix = "Free";
        suffix = Table.varString;
      }
    }
    else if (tree.getType() == annotParser.CELL) {
      String cellLabel = ((CommonTree) tree.getChild(0)).getText();
      cells.clear();
      cells.addAll(Table.labelToCell.get(cellLabel).cells);
      if (!cells.isEmpty()) {
        cellBag = (CommonTree) tree.getChild(1);
      }
      else
        return;
    }

    boolean isVar = false;
    if (cellBag != null) {
      Set<CommonTree> nodes = new HashSet<CommonTree>();

      for (int index = 0; index < cellBag.getChildCount(); index++) {
        CommonTree item = (CommonTree) cellBag.getChild(index);

        if (item.getType() == annotParser.CELL) {
          String cellLabel = ((CommonTree) item.getChild(0)).getText();
          Table.Cell cell = Table.labelToCell.get(cellLabel);
          if (cells.contains(cell))
            cells.remove(cell);
          else {
            nodes.add(item);
            cellBag.deleteChild(index);
            index--;
          }
        }
        else if (item.getType() == annotParser.IDENTIFIER) {
          isVar = true;
          prefixStack.push(prefix);
          suffixStack.push(suffix);

          String var =  item.getText();
          if (var.startsWith("?") || var.startsWith("!")) {
            prefix = var.substring(0, 1);
            suffix = var.substring(1);
          }
          else {
            prefix = "Free";
            suffix = var;
          }

          cellBag.deleteChild(index);
          index--;
        }
      }

      Iterator<Table.Cell> cellIterator = cells.iterator();
      while (cellIterator.hasNext()) {
        Table.Cell cell = cellIterator.next();
        addCell(cellBag, cell);
      }

      Iterator<CommonTree> nodeIterator = nodes.iterator();
      while (nodeIterator.hasNext()) {
        CommonTree node = nodeIterator.next();
        String subcellLabel = ((CommonTree) node.getChild(0)).getText();
        Table.Cell subcell = Table.labelToCell.get(subcellLabel);

        for (int index = 0; index < cellBag.getChildCount(); index++) {
          CommonTree item = (CommonTree) cellBag.getChild(index);
          String cellLabel = ((CommonTree) item.getChild(0)).getText();
          Table.Cell cell = Table.labelToCell.get(cellLabel);
          if (cell.isAncestor(subcell)) {
            ((CommonTree) item.getChild(1)).addChild(node);
            break;
          }
        }
      }
    }

    for (int i = 0; i < tree.getChildCount(); i++)
      completeConfig((CommonTree) tree.getChild(i));

    if (isVar) {
      prefix = prefixStack.pop();
      suffix = suffixStack.pop();
    }
  }

  public static void main (String[] args) {
/*
    try {
      ANTLRInputStream input = new ANTLRInputStream(System.in);
      annotLexer lexer = new annotLexer(input);
      CommonTokenStream tokens = new CommonTokenStream(lexer);
      annotParser parser = new annotParser(tokens);
      CommonTree tree = (CommonTree) parser.annot().getTree();
      CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
      annotToMaude maudifier = new annotToMaude(nodes);
      CommonTree maudifiedTree = (CommonTree) maudifier.root().getTree();

      System.out.println(TreeUtils.toTreeString(tree, 0));
      System.out.println(TreeUtils.toMaudeString(maudifiedTree));
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (RecognitionException e) {
      e.printStackTrace();
    }
*/
  }
}
