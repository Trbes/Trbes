class CustomDomainConstraint
  def self.matches?(request)
    matching_group?(request)
  end

  def self.matching_group?(request)
    bare_host = request.subdomain.present? ? request.host.gsub("#{request.subdomain}.", "") : request.host
    return false if request.subdomain == "www" && bare_host.include?(ENV["APP_HOST"])
    Group.where("custom_domain LIKE ?" , "%#{bare_host}%").any? || request.subdomain =~ SubdomainValidator::REG_EXP
  end
end
