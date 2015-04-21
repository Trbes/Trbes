function iconify_links() {
    $(function() {
        $(".iconify").each(function() {
            var link = $(this).data("iconify-target");
            var size = parseInt($(this).data("iconify-size")) || 16;
            $(this).css({
                background: "url(http://grabicon.com/icon?size=" + size + "&origin=" + window.location.host + "&domain=" + link + ") 0px 5px no-repeat",
                "padding-left": Math.round(size + 4) + "px"
            });
        });
    })
}
