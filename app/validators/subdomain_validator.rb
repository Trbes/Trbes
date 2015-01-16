class SubdomainValidator < ActiveModel::EachValidator
  REG_EXP = /\A(?!www)^[a-z\d]+([-_][a-z\d]+)*\z/

  def validate_each(record, attribute, value)
    unless value =~ REG_EXP
      record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid'))
    end
  end
end
