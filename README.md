types-with-system
=================


This is the example code for the article "Typen mit System - verständliche und flexible Typsysteme für DSLs" in the free German magazine ["Kaffeeklatsch"](http://www.bookware.de).(TODO: insert year/month)

It shows how to write a simple type system using the Xtext DSL framework.


Installation
------------


- Download appropriate "Full Eclipse from"

  http://www.eclipse.org/Xtext/download.html

- Unpack it.
	
    **WINDOWS ONLY:** Unpack it immediately in `C:\`! Otherwise the 
  long filenames and deep directory structure will result in strange effects!

- Start Eclipse

- Install latest "Xtext Antlr Runtime Feature" from

	http://download.itemis.de/updates/

- Import projects into Eclipse.

- Find the grammar file `Typesystem.xtext` and execute "Run As" -> "Generate Xtext
  artifacts" in the context menu.

Now you can hack the type system. 

Running
-------

You can either start the JUnit tests or you can try it "live".

If you want to try the language live in an editor, start a second Eclipse. Execute 
"Run As" -> "Eclipse Application" in the context menu of the *.ui project. 
Inside the second Eclipse create a new "Generic Project" and create files with 
the extension `.expr`.
