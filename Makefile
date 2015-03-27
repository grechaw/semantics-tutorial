MLCP = ./mlcp-Hadoop2-1.3-1/bin/mlcp.sh
SEED = database/seed-data/
USERNAME = admin
PASSWORD = admin
AUTH = --digest --user $(USERNAME):$(PASSWORD)
EXPORT_DUMMY = .export
INIT_DUMMY = .init
PAGES = *.html
SERVICES = config/resources/*

init: $(INIT_DUMMY)
.PHONY: init
	

$(INIT_DUMMY): Makefile database/appserver-properties.json database/database-properties.json
	curl -i -X PUT -Hcontent-type:application/json -d@database/appserver-properties.json $(AUTH) "http://localhost:8002/manage/v2/servers/App-Services/properties?group-id=Default"
	curl -i -X PUT -Hcontent-type:application/json -d@database/database-properties.json $(AUTH) "http://localhost:8002/manage/v2/databases/Documents/properties?group-id=Default"
	touch $(INIT_DUMMY)

# this section is for data prep - not needed for tutorial after data is done.
dataprep: $(INIT_DUMMY) 
	curl -i -X PUT -Hcontent-type:application/json $(AUTH) -d@$(SEED)/scratch.json http://localhost:8000/v1/documents?uri=scratch.json
	curl -i -X PUT -Hcontent-type:application/json $(AUTH) -d@$(SEED)/playerproperties.json http://localhost:8000/v1/documents?uri=playerproperties.json
	curl -i -X PUT -Hcontent-type:application/json $(AUTH) -d@$(SEED)/teamproperties.json http://localhost:8000/v1/documents?uri=teamproperties.json
	curl -i -X PUT -Hcontent-type:application/json $(AUTH) -d@$(SEED)/matchproperties.json http://localhost:8000/v1/documents?uri=matchproperties.json

deploy: $(INIT_DUMMY) $(PAGES) $(SERVICES)
	for p in $(PAGES); do \
		curl -i -X PUT -Hcontent-type:text/html -d@$$p $(AUTH) http://localhost:8000/v1/documents?uri=$$p ; \
	done
	for s in $(SERVICES); do \
		curl -i -X PUT -Hcontent-type:application/javascript $(AUTH) -d@$$s http://localhost:8000/v1/$$s ; \
	done
	#curl -i -X PUT -Hcontent-type:application/javascript $(AUTH) -d@database/services/testScratch.sjs http://localhost:8000/v1/config/resources/testScratch

test: deploy
	curl -i -X GET -Haccept:application/json $(AUTH) "http://localhost:8000/v1/resources/infobox?rs:subject=chuck"

export: $(EXPORT_DUMMY)

$(EXPORT_DUMMY): database
	$(MLCP) EXPORT -output_file_path export -output_type archive -compress true -username $(USERNAME) -password $(USERNAME) -host localhost -port 8000
	touch $(EXPORT_DUMMY)
	
import: $(INIT_DUMMY)
	$(MLCP) IMPORT -input_file_path /home/cgreer/Documents/MarkLogicWorld2015/semantics-tutorial/raw-data/wikidata/ -input_file_type rdf -input_compressed true -input_compression_codec GZIP -username admin -password admin -host localhost -port 8000
	
.PHONY: clean
clean:
	rm -rf export
	rm $(INIT_DUMMY)
	rm $(EXPORT_DUMMY)

.PHONY: deploy
.PHONY: test
