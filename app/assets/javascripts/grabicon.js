function iconify_link(elem) {
    var parser = document.createElement("a");
    parser.href = elem.data("iconify-target");
    var link = parser.hostname;

    var size = parseInt(elem.data("iconify-size")) || 16;
    elem.css({
        background: "url(http://grabicon.com/icon?size=" + size + "&origin=" + window.location.host + "&domain=" + link + "&key=" + gon.grabicon_api_key + ") 0px 5px no-repeat",
        "padding-left": Math.round(size + 4) + "px"
    });
}


function iconify_links() {
    $(function() {
        $(".iconify").each(function() {
            iconify_link($(this));
        });
    })
}

