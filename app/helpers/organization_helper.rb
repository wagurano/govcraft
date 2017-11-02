module OrganizationHelper
  def fetch_organization_from_request
    return nil unless organizationable_request?(request)
    Organization.find_by_slug request.subdomains[0]
  end

  def organizationable_request?(request)
    request.host != Rails.application.routes.default_url_options[:host] and request.subdomains.any?
  end
end
