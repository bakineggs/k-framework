("toplevel",,(($stat,,("assign",,true,,("name",,"JSAST"),,("call",,($function,,null,,(),,(($stat,,("string",,"use strict")),,($var,,(("_outputTerminal"),,("_outputPrefixes"),,("_outputElement"),,("_asASTString"),,("_normalizedOutput"),,("_asSExpression"))),,($stat,,("assign",,true,,("name",,"_outputTerminal"),,($function,,"_outputTerminal",,("substrings",,"element"),,(($switch,,("unary-prefix",,"typeof",,("name",,"element")),,((("string",,"object"),,(($if,,("binary",,"===",,("name",,"element"),,("name",,"null")),,($block,,(($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,"null")))))),,($block,,(($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,"$"),,("name",,"element"))))))),,($break,,null))),,(("string",,"undefined"),,(($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,"undefined")))),,($break,,null))),,(("string",,"string"),,(($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,"\""),,("call",,("dot",,("name",,"element"),,"replace"),,(("regexp",,"\\"",,"g"),,("string",,"\\""))),,("string",,"\"")))),,($break,,null))),,(null,,(($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("name",,"element")))))))))))),,($stat,,("assign",,true,,("name",,"_outputPrefixes"),,($function,,"_outputPrefixes",,("levels"),,(($var,,(("count",,("dot",,("name",,"levels"),,"length")),,("output",,("array",,())),,("index"),,("isLastElement"))),,($for,,("assign",,true,,("name",,"index"),,("num",,0)),,("binary",,"<",,("name",,"index"),,("name",,"count")),,("assign",,"+",,("name",,"index"),,("num",,1)),,($block,,(($stat,,("assign",,true,,("name",,"isLastElement"),,("sub",,("name",,"levels"),,("name",,"index")))),,($stat,,("call",,("dot",,("name",,"output"),,"push"),,(("conditional",,("name",,"isLastElement"),,("string",,"    "),,("string",,"|   ")))))))),,($return,,("name",,"output")))))),,($stat,,("assign",,true,,("name",,"_outputElement"),,($function,,"_outputElement",,("lines",,"element",,"levels"),,(($var,,(("currentLine"))),,($if,,("call",,("dot",,("name",,"Array"),,"isArray"),,(("name",,"element"))),,($block,,(($stat,,("call",,("name",,"_asASTString"),,(("name",,"element"),,("name",,"lines"),,("name",,"levels")))))),,($block,,(($stat,,("assign",,true,,("name",,"currentLine"),,("call",,("dot",,("name",,"lines"),,"pop"),,()))),,($stat,,("call",,("dot",,("name",,"currentLine"),,"push"),,(("string",,"--> ")))),,($stat,,("call",,("name",,"_outputTerminal"),,(("name",,"currentLine"),,("name",,"element")))),,($stat,,("call",,("dot",,("name",,"lines"),,"push"),,(("call",,("dot",,("name",,"currentLine"),,"join"),,(("string",,""))))))))))))),,($stat,,("assign",,true,,("name",,"_asASTString"),,($function,,"_asASTString",,("elements",,"lines",,"levels"),,(($var,,(("index",,("num",,0)),,("count",,("dot",,("name",,"elements"),,"length")),,("match",,("binary",,"-",,("name",,"count"),,("num",,1))),,("isLastElement",,("binary",,"<=",,("name",,"count"),,("num",,1))),,("currentLine",,("call",,("dot",,("name",,"lines"),,"pop"),,())),,("element"))),,($stat,,("call",,("dot",,("name",,"currentLine"),,"push"),,(("string",,"--(")))),,($if,,("binary",,"===",,("name",,"count"),,("num",,0)),,($block,,(($stat,,("call",,("dot",,("name",,"currentLine"),,"push"),,(("string",,")")))),,($stat,,("call",,("dot",,("name",,"lines"),,"push"),,(("call",,("dot",,("name",,"currentLine"),,"join"),,(("string",,"")))))),,($return,,null))),,undefined),,($stat,,("call",,("dot",,("name",,"currentLine"),,"push"),,(("conditional",,("name",,"isLastElement"),,("string",,")"),,("string",,"-"))))),,($do,,("name",,"true"),,($block,,(($stat,,("call",,("dot",,("name",,"lines"),,"push"),,(("name",,"currentLine")))),,($stat,,("call",,("dot",,("name",,"levels"),,"push"),,(("name",,"isLastElement")))),,($stat,,("assign",,true,,("name",,"element"),,("sub",,("name",,"elements"),,("name",,"index")))),,($stat,,("call",,("name",,"_outputElement"),,(("name",,"lines"),,("name",,"element"),,("name",,"levels")))),,($stat,,("call",,("dot",,("name",,"levels"),,"pop"),,())),,($if,,("name",,"isLastElement"),,($block,,(($return,,null))),,undefined),,($stat,,("assign",,true,,("name",,"isLastElement"),,("binary",,"===",,("unary-prefix",,"++",,("name",,"index")),,("name",,"match")))),,($stat,,("assign",,true,,("name",,"currentLine"),,("call",,("name",,"_outputPrefixes"),,(("name",,"levels"))))),,($stat,,("call",,("dot",,("name",,"currentLine"),,"push"),,(("conditional",,("name",,"isLastElement"),,("string",,")-"),,("string",,"|-")))))))))))),,($stat,,("assign",,true,,("name",,"_normalizedOutput"),,($function,,"_normalizedOutput",,("lines"),,(($var,,(("output",,("array",,())),,("maxLength",,("num",,0)),,("length"),,("count"))),,($stat,,("call",,("dot",,("name",,"lines"),,"forEach"),,(($function,,null,,("line"),,(($stat,,("assign",,true,,("name",,"length"),,("dot",,("name",,"line"),,"length"))),,($if,,("binary",,">",,("name",,"length"),,("name",,"maxLength")),,($block,,(($stat,,("assign",,true,,("name",,"maxLength"),,("name",,"length"))))),,undefined)))))),,($stat,,("call",,("dot",,("name",,"lines"),,"forEach"),,(($function,,null,,("line"),,(($stat,,("call",,("dot",,("name",,"output"),,"push"),,(("name",,"line")))),,($stat,,("assign",,true,,("name",,"count"),,("binary",,"-",,("name",,"maxLength"),,("dot",,("name",,"line"),,"length")))),,($while,,("binary",,">",,("unary-postfix",,"--",,("name",,"count")),,("num",,0)),,($block,,(($stat,,("call",,("dot",,("name",,"output"),,"push"),,(("string",," "))))))),,($stat,,("call",,("dot",,("name",,"output"),,"push"),,(("string",,"    \"),,("string",,"
"))))))))),,($stat,,("call",,("dot",,("name",,"output"),,"pop"),,())),,($stat,,("call",,("dot",,("name",,"output"),,"push"),,(("string",,"\"")))),,($stat,,("assign",,true,,("name",,"output"),,("call",,("dot",,("name",,"output"),,"join"),,(("string",,""))))),,($return,,("name",,"output")))))),,($stat,,("assign",,true,,("name",,"_asSExpression"),,($function,,"_asSExpression",,("elements",,"separator",,"substrings"),,(($var,,(("element"),,("index",,("num",,0)),,("count",,("dot",,("name",,"elements"),,"length")))),,($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,"(")))),,($if,,("binary",,">",,("name",,"count"),,("num",,0)),,($block,,(($do,,("name",,"true"),,($block,,(($stat,,("assign",,true,,("name",,"element"),,("sub",,("name",,"elements"),,("name",,"index")))),,($if,,("call",,("dot",,("name",,"Array"),,"isArray"),,(("name",,"element"))),,($block,,(($stat,,("call",,("name",,"_asSExpression"),,(("name",,"element"),,("name",,"separator"),,("name",,"substrings")))))),,($block,,(($stat,,("call",,("name",,"_outputTerminal"),,(("name",,"substrings"),,("name",,"element"))))))),,($if,,("binary",,">=",,("unary-prefix",,"++",,("name",,"index")),,("name",,"count")),,($block,,(($break,,null))),,undefined),,($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("name",,"separator"))))))))),,undefined),,($stat,,("call",,("dot",,("name",,"substrings"),,"push"),,(("string",,")")))))))),,($stat,,("assign",,true,,("dot",,("dot",,("name",,"Array"),,"prototype"),,"asDiagram"),,($function,,"asDiagram",,(),,(($var,,(("lines",,("array",,(("string",,"\""),,("array",,(("string",," -")))))))),,($stat,,("call",,("name",,"_asASTString"),,(("name",,"this"),,("name",,"lines"),,("array",,(("name",,"true")))))),,($stat,,("call",,("dot",,("name",,"lines"),,"push"),,(("string",,"")))),,($return,,("call",,("name",,"_normalizedOutput"),,(("name",,"lines")))))))),,($stat,,("assign",,true,,("dot",,("dot",,("name",,"Array"),,"prototype"),,"asSExpression"),,($function,,"asSExpression",,("options_"),,(($var,,(("separator",,("binary",,"||",,("binary",,"&&",,("name",,"options_"),,("dot",,("name",,"options_"),,"separator")),,("string",,", "))),,("substrings",,("array",,())))),,($stat,,("call",,("name",,"_asSExpression"),,(("name",,"this"),,("name",,"separator"),,("name",,"substrings")))),,($return,,("call",,("dot",,("name",,"substrings"),,"join"),,(("string",,"")))))))),,($return,,("object",,(("generate",,($function,,"generate",,("fileNameWithExt",,"isStrictMode_"),,(($var,,(("dirName",,("string",,"/Users/m3rabb/Dev/Maude/k-framework/examples/inProgress/kJS/examples/")),,("fileName",,("call",,("dot",,("name",,"fileNameWithExt"),,"replace"),,(("regexp",,"\.js$",,""),,("string",,"")))),,("path",,("binary",,"+",,("name",,"dirName"),,("name",,"fileName"))),,("isStrictMode",,("binary",,"||",,("name",,"isStrictMode_"),,("name",,"false"))),,("sourceFile"),,("source"),,("ast"),,("sexp"),,("diagram"),,("sexpFile"),,("diagramFile"),,("sexpFlag"),,("resultFlag"))),,($stat,,("call",,("dot",,("dot",,("dot",,("name",,"netscape"),,"security"),,"PrivilegeManager"),,"enablePrivilege"),,(("string",,"UniversalXPConnect")))),,($if,,("binary",,"===",,("call",,("dot",,("name",,"fileNameWithExt"),,"search"),,(("regexp",,"\.js$",,""))),,("unary-prefix",,"-",,("num",,1))),,($block,,(($return,,("string",,"ERROR: Must be a .js file!")))),,undefined),,($stat,,("assign",,true,,("name",,"sourceFile"),,("call",,("dot",,("name",,"FileIO"),,"open"),,(("binary",,"+",,("name",,"path"),,("string",,".js")))))),,($if,,("unary-prefix",,"!",,("call",,("dot",,("name",,"sourceFile"),,"exists"),,())),,($block,,(($return,,("binary",,"+",,("binary",,"+",,("string",,"ERROR "),,("name",,"fileNameWithExt")),,("string",," doesn't exist!"))))),,undefined),,($stat,,("assign",,true,,("name",,"source"),,("call",,("dot",,("name",,"FileIO"),,"read"),,(("name",,"sourceFile"))))),,($stat,,("assign",,true,,("name",,"ast"),,("call",,("name",,"parse"),,(("name",,"source"),,("name",,"isStrictMode"),,("name",,"true"))))),,($stat,,("assign",,true,,("name",,"sexp"),,("call",,("dot",,("name",,"ast"),,"asSExpression"),,()))),,($stat,,("assign",,true,,("name",,"diagram"),,("call",,("dot",,("name",,"ast"),,"asDiagram"),,()))),,($stat,,("assign",,true,,("name",,"sexpFile"),,("call",,("dot",,("name",,"FileIO"),,"open"),,(("binary",,"+",,("name",,"path"),,("string",,".sexp")))))),,($stat,,("assign",,true,,("name",,"diagramFile"),,("call",,("dot",,("name",,"FileIO"),,"open"),,(("binary",,"+",,("name",,"path"),,("string",,".diagram")))))),,($stat,,("assign",,true,,("name",,"resultFlag"),,("call",,("dot",,("name",,"FileIO"),,"write"),,(("name",,"sexpFile"),,("name",,"sexp"))))),,($stat,,("assign",,true,,("name",,"resultFlag"),,("binary",,"&&",,("name",,"resultFlag"),,("call",,("dot",,("name",,"FileIO"),,"write"),,(("name",,"diagramFile"),,("name",,"diagram")))))),,($return,,("name",,"resultFlag")))))))))),,())))))