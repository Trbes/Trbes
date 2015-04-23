# config/initializers/attribute_normalizer.rb
AttributeNormalizer.configure do |config|

  config.normalizers[:htmlize] = lambda do |value, options|
    value.is_a?(String) ?
      value
        .strip
        .gsub(/\r\n/, '<br>')
        .gsub(/(\s|\u00a0|&nbsp;)+/, ' ')
        .gsub(/(\<br\>){2,}/, '<br><br>')
        .gsub(/^(\<br\>)+/, "")
        .gsub(/(\<br\>)+$/, "") :
      value
  end

  # The default normalizers if no :with option or block is given is to apply the :strip and :blank normalizers (in that order).
  # You can change this if you would like as follows:
  # config.default_normalizers = :strip, :blank

  # You can enable the attribute normalizers automatically if the specified attributes exist in your column_names. It will use
  # the default normalizers for each attribute (e.g. config.default_normalizers)
  # config.default_attributes = :name, :title

  # Also, You can add a specific attribute to default_attributes using one or more normalizers:
  # config.add_default_attribute :name, :with => :truncate
end
