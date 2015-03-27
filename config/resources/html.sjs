
function htmlify(context, params) {
    var uri = params.uri;
    var doc = cts.doc(uri);
    context.outputTypes = [ "text/html" ];
    return doc;
};

exports.GET = htmlify;

