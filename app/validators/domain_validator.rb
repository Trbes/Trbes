class DomainValidator < ActiveModel::EachValidator
  REG_EXP = /^(([a-z0-9-\.]*)\.)?
              ([a-z0-9-]+)\.
              ([a-z]{2,5})
              (:[0-9]{1,5})?
              (\/)?$/ix

  def validate_each(record, attribute, value)
    return if value =~ REG_EXP

    record.errors[attribute] << (options[:message] || I18n.t("errors.messages.invalid"))
  end
end
