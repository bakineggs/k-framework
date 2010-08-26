First, set up CIL:
	- move to ./cil directory 
	- Configure and compile it as per its INSTALL file.  
	
Now, configure the Makefile:
	- set GCC

Finally, build the tool:
	- run "make dist"  in the main C directory

	
Changes to the CABS abstract syntax tree:
	- Different cases and names (e.g., "Signed" instead of "Tsigned", "DecDef" instead of "DECDEF", etc.)
	- "Identifier" around strings
	- Flattened SpecifierElem
	- Wrap statements with StatementLoc holding the location
	PROTO => Prototype
	NO_INIT => NoInit