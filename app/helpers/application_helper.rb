module ApplicationHelper
  BOOTSTRAP_FLASH_MAPPER = {
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-warning",
    notice: "alert-info"
  }.freeze

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MAPPER.fetch(flash_type.to_sym, flash_type)
  end

  HUMANE_FLASH_MAPPER = {
    success: "humane-libnotify-success",
    error: "humane-libnotify-error",
    alert: "humane-libnotify-error",
    notice: "humane-libnotify-info"
  }.freeze

  def humane_class_for(flash_type)
    HUMANE_FLASH_MAPPER.fetch(flash_type.to_sym, flash_type)
  end

  def present(object)
    if object.respond_to?(:map)
      present_as_array(object)
    else
      klass = "#{object.class}Presenter".constantize

      klass.new(object, self)
    end
  end

  def present_as_array(object)
    if object.any?
      klass = "#{object.first.class}Presenter".constantize

      object.map { |el| klass.new(el, self) }
    else
      []
    end
  end

  def current_path?(path)
    "active" if request.url.include?(path)
  end

  def tweet_intent(opts = {})
    params = []
    opts.each { |key, value| params << "#{key}=#{ URI.encode(value) }" }
    "https://twitter.com/intent/tweet?" + params.join("&")
  end
end
