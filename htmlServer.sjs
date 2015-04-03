
function htmlify(context, params) {
    var home = params.home;
    var doc = xdmp.filesystemFile(home + "/tutorial.html");
    context.outputTypes = [ "text/html" ];
    return doc;
};

exports.GET = htmlify;

