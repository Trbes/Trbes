function iconify_links(size) {
    $(function() {
        $(".iconify").each(function() {
            var link = $(this).data("iconify-target");
            $(this).css({
                background: "url(http://grabicon.com/icon?size=" + size + "&origin=" + window.location.host + "&domain=" + link + ") left center no-repeat",
                "padding-left": Math.round(size * 1.25) + "px"
            });
        });
    })
}
