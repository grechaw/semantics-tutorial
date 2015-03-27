#Semantics Tutorial Project

This is a super quick-and-dirty way to make a MarkLogic application

It uses an angular page-per-app.  It uses the OOTB REST server on port 8000

#requires

* make
* curl
* MarkLogic 8+ installed, running

#Quickstart

```
make init
make deploy
```

After this, you can look at the application at

http://localhost:8000/v1/resources/html?index.html

The architecture of this app consists of N combinations of pages and extensions, with an index.html to tie them together.

The first page runs sparql queries
the second one runs an extension.

when you run `make deploy` 

the various html files are put onto the server so you can server them with the above link pattern.
The extensions are referenced at

http://localhost:8000/v1/resources/{name}

You'll find the extensions at config/resources/*.sjs so you can make new ones there.  There is only one in this initial commit.

Take a look at the Makefile for more information

As of this commit, there is no seed data import with this projecct.
That will be forthcoming.

