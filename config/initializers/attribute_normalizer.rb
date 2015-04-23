# config/initializers/attribute_normalizer.rb
AttributeNormalizer.configure do |config|
  config.normalizers[:htmlize] = lambda do |value, _options|
    if value.is_a?(String)
      value
        .strip
        .gsub(/\r\n/, "<br>")
        .gsub(/(\s|\u00a0|&nbsp;)+/, " ")
        .gsub(/(\<br\>){2,}/, "<br><br>")
        .gsub(/^(\<br\>)+/, "")
        .gsub(/(\<br\>)+$/, "")
    else
      value
    end
  end
end
