#Semantics Tutorial Project

This is a super quick-and-dirty way to make a MarkLogic application

It uses an angular page-per-app.  It uses the OOTB REST server on port 8000

#requires

* java
* curl  (provided for Windows)
* scripting ( sh or .bat )
* MarkLogic 8+ installed, running

#Quickstart

```
sh setup.sh
```

OR, on Windows

```
setup.bat
```

After this, you can look at the application at

http://localhost:8000/v1/resources/htmlServer?rs:home={path-to-tutorial}

The architecture of this app consists of one html page and some extensions.

The page, at tutorial.html, invokes SPARQL queries or an extension depending on 
which form is used.

Data is loaded from data/  There is JSON, and XML data in this directory.  Some
of the XML files are dumps of the internal triples format of MarkLogic managed triples.

