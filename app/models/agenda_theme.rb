class AgendaTheme < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :agendas, uniq: true
  has_many :issues, dependent: :nullify
  has_many :options, through: :issues
  mount_uploader :cover, ImageUploader

  def speaker_positions
    {
      '2017-president' => ['대선주자'],
      'votefuture' => ['대선주자'],
    }.fetch(slug, nil)
  end
end
