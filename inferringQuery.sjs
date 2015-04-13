var sem = require("/MarkLogic/semantics.xqy");

function get(context, params) {

    var query = params.query;
    var rulesets = params.rulesets;

    /* if just one ruleset was passed, it's not in an array */
    if (!Array.isArray(rulesets)) {
        rulesets = [ rulesets ];
    }
    
xdmp.log(rulesets);
    context.outputTypes = [ 'application/sparql-results+json' ]; 
    var results = sem.sparql(query, null, null, sem.rulesetStore(rulesets, sem.store()));
    return sem.queryResultsSerialize(results, "json");
};

exports.GET = get;

