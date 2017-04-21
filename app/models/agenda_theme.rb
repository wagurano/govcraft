class AgendaTheme < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :agendas, uniq: true
  has_many :issues, dependent: :nullify
  has_many :options, through: :issues
  mount_uploader :cover, ImageUploader
end
