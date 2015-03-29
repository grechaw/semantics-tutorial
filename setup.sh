#!/bin/bash

MLCP="./mlcp-Hadoop2-1.3-1/bin/mlcp.sh"
USERNAME=admin
PASSWORD=admin
CURL="curl -i -X PUT --digest --user $USERNAME:$PASSWORD"
PWD=`pwd`

# setup the database and apperserver.
# these two steps enable the triples index and can set the inference
# size.   See config/appserver-properties.json and config/database-properties.json
# These really only need to be done once
$CURL -Hcontent-type:application/json -d@database-properties.json "http://localhost:8002/manage/v2/databases/Documents/properties?group-id=Default"

# installs the tutorial html page on MarkLogic REST server as a document.
$CURL -Hcontent-type:text/html -d@tutorial.html http://localhost:8000/v1/documents?uri=tutorial.html 

# intall an extension that can be the web server for this application
$CURL -Hcontent-type:application/javascript -d@htmlServer.sjs http://localhost:8000/v1/config/resources/htmlServer ; 

# install the extension to be called by angular
$CURL -Hcontent-type:application/javascript -d@semanticExtension.sjs http://localhost:8000/v1/config/resources/semanticExtension ; 

# import RDF data
$MLCP IMPORT -input_file_path data/rdf -input_file_type rdf -username $USERNAME -password $PASSWORD -host localhost -port 8000
# import JSON data
$MLCP IMPORT -input_file_path data/json -username $USERNAME -password $PASSWORD -host localhost -port 8000 -output_uri_replace "$PWD/data/json,''"
$MLCP IMPORT -input_file_path data/xml -username $USERNAME -password $PASSWORD -host localhost -port 8000 -output_uri_replace "$PWD/data/xml,''"

