module Reportable
  extend ActiveSupport::Concern

  included do
    has_many :reports, as: :reportable
  end

  def reported_by someone
    reports.exists? user: someone
  end

  def screened?
    reports_count > 10 or reports.exists?(force: true)
  end
end
