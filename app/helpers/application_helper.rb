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
end
