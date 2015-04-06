var sem = require("/MarkLogic/semantics.xqy");

function get(context, params) {

    xdmp.log(params);
    xdmp.log(params.query);
    var query = params.query;
    var term = params.term;
    
    var results = {"results" : ["some", "json", "in", "an", "array"]};

/*
    var results = sem.sparql(query, null, null, sem.rulesetStore(rulesets, sem.store()));
    for (answer of searchNodes) {
        xdmp.log("answer " + answer);
        var result = sem.sparql(query, {param : answer});
        results.push(result);
    }
*/

    context.outputTypes = [ 'application/json' ]; 
    return results;
};

exports.GET = get;

