#!/bin/bash

MLCP="./mlcp-Hadoop2-1.3-1/bin/mlcp.sh"
USERNAME=admin
PASSWORD=admin
CURL="curl -X PUT --digest --user $USERNAME:$PASSWORD"
PWD=`pwd`

## setup the database and apperserver.

# these two steps enable the triples index and can set the inference
# Really only needs to be done once
echo "Configuring database"
#$CURL -Hcontent-type:application/json -d@database-properties.json "http://localhost:8002/manage/v2/databases/Documents/properties?group-id=Default"
$CURL -Hcontent-type:application/json -d@database-properties.json "http://localhost:8002/manage/v2/databases/Documents/properties"

# intall an extension that can be the web server for this application
# this is the "middle tier" that serves the HTML pages for the application.
echo "Installing HTML page server extension"
$CURL -Hcontent-type:application/javascript -d@htmlServer.sjs http://localhost:8000/v1/config/resources/htmlServer 

echo "Installing the semantic extensions" ;
$CURL -Hcontent-type:application/javascript -d@inferringQuery.sjs http://localhost:8000/v1/config/resources/inferringQuery 
$CURL -Hcontent-type:application/javascript -d@semanticExtension.sjs http://localhost:8000/v1/config/resources/semanticExtension 

echo "Loading Data..."
$MLCP IMPORT -input_file_path data -username $USERNAME -password $PASSWORD -host localhost -port 8000 -output_uri_replace "$PWD/data/json,'',$PWD/data/xml,'',$PWD/data/xml/triples,''" -output_collections "http://marklogic.com/semantics#default-graph","mlw16"

