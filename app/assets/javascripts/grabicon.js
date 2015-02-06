function iconify_links(size) {
    $(function() {
        $("a[href^='http'].iconify").each(function() {
            $(this).css({
                background: "url(http://grabicon.com/icon?size=" + size + "&domain=" + this.href + ") left center no-repeat",
                "padding-left": Math.round(size * 1.25) + "px"
            });
        });
    })
}
