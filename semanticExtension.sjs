require("/MarkLogic/semantics.xqy");

function get(context, params) {

    return { "stuff" : {
        "context":context, "params": params
      }
    };

};


exports.GET = get;

