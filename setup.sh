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

# install the extension that's used in the second form on the tutorial page.
curl -i -X PUT -Hcontent-type:application/javascript $AUTH -d@$s http://localhost:8000/v1/$s ; 
	#curl -i -X PUT -Hcontent-type:application/javascript $(AUTH) -d@database/services/testScratch.sjs http://localhost:8000/v1/config/resources/testScratch

	$(MLCP) EXPORT -output_file_path export -output_type archive -compress true -username $(USERNAME) -password $(USERNAME) -host localhost -port 8000
	touch $(EXPORT_DUMMY)
	
import: $(INIT_DUMMY)
	$(MLCP) IMPORT -input_file_path  -input_file_type rdf -input_compressed true -input_compression_codec GZIP -username admin -password admin -host localhost -port 8000
	
.PHONY: clean
clean:
	rm -rf export
	rm $(INIT_DUMMY)
	rm $(EXPORT_DUMMY)

.PHONY: deploy
.PHONY: test
