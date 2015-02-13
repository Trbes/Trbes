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

  def present(object)
    if object.respond_to?(:map) && object.any?
      klass = "#{object.first.class}Presenter".constantize

      object.map { |el| klass.new(el, self) }
    else
      klass = "#{object.class}Presenter".constantize

      klass.new(object, self)
    end
  end

  def current_path?(path)
    "active" if request.url.include?(path)
  end
end
