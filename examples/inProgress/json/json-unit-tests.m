--- set print with parentheses on .
--- set print mixfix off .

load json

red 	{ } 
==Bool 	o(.JsonProperties) .

red 	{"s" : 234} 
==Bool 	o("s" : 234) .

red 	{"a" : [ ]}	
==Bool 	o("a" : a(.List{JsonElement})) .

red 	{"a" : [1,2,3]} 
==Bool 	o("a" : a(1,2,3)) .

red 	{  "a" : [{"s" : 123, "e" : {"b" : [1]}}]} 
==Bool 	o("a" : a(o("e" : o("b" : a(1)) "s" : 123))) .

red 	{"a" : {}, "b" : "str", "c" : [1,2,3]} 
==Bool	o("a" : o(.JsonProperties) "b" : "str" "c" : a(1,2,3)) .

red		{"a" : 1, "b" : 2, "c" : 3} 
==Bool	o("a" : 1 "b" : 2 "c" : 3) .

red		{"a" : 1, "a" : 2, "a" : 3} 
==Bool	o("a" : 1 "a" : 2 "a" : 3) .

red		{"b" : 2, "c" : 3, "a" : 1} 
==Bool	o("a" : 1 "b" : 2 "c" : 3) .

red		{"a" : {}, "b" : {"d" : 2}, "c" : {"e" : {"z" : 3 , "q" : [9,8]}}} 
==Bool	o("a" : o(.JsonProperties) "b" : o("d" : 2) "c" : o("e" : o("q" : a(9,
    8) "z" : 3))) .
