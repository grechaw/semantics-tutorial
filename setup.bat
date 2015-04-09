set MLCP=.\mlcp-Hadoop2-1.3-1\bin\mlcp.bat
set USERNAME=admin
set PASSWORD=admin
set CURL=curl-7.3.0-win64-ssl-sspi\curl.exe -X PUT --digest --user %USERNAME%:%PASSWORD%
set PWD=%~dp0
set PWD=%PWD:\=/%

rem setup the database and apperserver.

echo "Configuring database"
%CURL% -Hcontent-type:application/json -d@database-properties.json "http://localhost:8002/manage/v2/databases/Documents/properties?group-id=Default"

echo "Installing HTML page server extension"
%CURL% -Hcontent-type:application/javascript -d@htmlServer.sjs http://localhost:8000/v1/config/resources/htmlServer 


echo "Installing the semantic extensions"
%CURL% -Hcontent-type:application/javascript -d@inferringQuery.sjs http://localhost:8000/v1/config/resources/inferringQuery 
%CURL% -Hcontent-type:application/javascript -d@semanticExtension.sjs http://localhost:8000/v1/config/resources/semanticExtension 


echo "loading data..."
%MLCP% IMPORT -input_file_path data -username %USERNAME% -password %PASSWORD% -host localhost -port 8000 -output_uri_replace "/%PWD%data/json,'',/%PWD%data/xml,'',/%PWD%data/xml/triples,''" -output_collections "http://marklogic.com/semantics#default-graph"

echo "Finished loading data"
pause
