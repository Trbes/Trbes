function iconify_external(scope_selector, size) {
    $(function() {
        $(scope_selector + " a[href^='http']").each(function() {
            $(this).css({
                background: "url(http://grabicon.com/icon?size=" + size + "&domain=" + this.href + ") left center no-repeat",
                "padding-left": Math.round(size * 1.25) + "px"
            });
        });
    })
}
