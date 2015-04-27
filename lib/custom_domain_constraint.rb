class CustomDomainConstraint
  def self.matches?(request)
    matching_group?(request)
  end

  def self.matching_group?(request)
    return false if request.subdomain == "www" && bare_host(request).include?(Trbes::Application.config.host)

    Group.where("custom_domain LIKE ?", "%#{bare_host(request)}%").any? ||
      request.subdomain =~ SubdomainValidator::REG_EXP
  end

  def self.bare_host(request)
    request.subdomain.present? ? request.host.gsub("#{request.subdomain}.", "") : request.host
  end
end
