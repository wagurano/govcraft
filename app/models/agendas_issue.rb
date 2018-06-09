class AgendasIssue < ActiveRecord::Base
  belongs_to :agenda
  belongs_to :issue
end
