module KaminariHelper
  def link_to_unless(condition, name, options = {}, html_options = {}, &block)
    options = url_for(options) if options.is_a? Hash
    if condition
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        content_tag(:span, name)
      end
    else
      link_to(name, options, html_options)
    end
  end
end
