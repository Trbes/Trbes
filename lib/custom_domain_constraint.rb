class CustomDomainConstraint
  def self.matches?(request)
    matching_group?(request)
  end

  def self.matching_group?(request)
    return false if request.subdomain == "www"
    Group.where(custom_domain: request.host).any? || request.subdomain =~ SubdomainValidator::REG_EXP
  end
end
