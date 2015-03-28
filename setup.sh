#!/bin/bash

MLCP= ./mlcp-Hadoop2-1.3-1/bin/mlcp.sh
USERNAME=admin
PASSWORD=admin
CURL=curl --digest --user $(USERNAME):$(PASSWORD)

# setup the database and apperserver.
# these two steps enable the triples index and can set the inference
# size.   See config/appserver-properties.json and config/database-properties.json
# These really only need to be done once
curl -i -X PUT -Hcontent-type:application/json -d@config/appserver-properties.json $AUTH "http://localhost:8002/manage/v2/servers/App-Services/properties?group-id=Default"
curl -i -X PUT -Hcontent-type:application/json -d@database/database-properties.json $AUTH "http://localhost:8002/manage/v2/databases/Documents/properties?group-id=Default"

# installs the tutorial html page on MarkLogic REST server as a document.
curl -i -X PUT -Hcontent-type:text/html -d@tutorial.html $AUTH http://localhost:8000/v1/documents?uri=tutorial.html 

# intall an extension that can be the web server for this application
curl -i -X PUT -Hcontent-type:application/javascript $AUTH -d@htmlServer.sjs http://localhost:8000/v1/config/resources/htmlServer ; 

# install the extension to be called by angular
curl -i -X PUT -Hcontent-type:application/javascript $AUTH -d@semanticExtension.sjs http://localhost:8000/v1/config/resources/semanticExtension ; 

$MLCP IMPORT -input_file_path data -input_file_type rdf -username $USERNAME -password $PASSWORD -host localhost -port 8000

