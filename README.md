#Semantics Tutorial Project

This is a super quick-and-dirty way to make a MarkLogic application

It uses an angular page-per-app.  It uses the OOTB REST server on port 8000

#requires

* curl
* bash
* MarkLogic 8+ installed, running

#Quickstart

```
sh setup.sh
```

After this, you can look at the application at

http://localhost:8000/v1/resources/html?rs:uri=tutorial.html

The architecture of this app consists of one html page and some extensions.

The page, at tutorial.html, invokes SPARQL queries or an extension depending on 
which form is used.

Data is loaded from data/  There is RDF, JSON, and XML data in this [[directory.]]

