class Opinion < ApplicationRecord
  include Likable
  include Votable

  extend Enumerize
  enumerize :stance, in: %w[agree partially disagree unsure]

  belongs_to :agent
  belongs_to :issue
  has_many :notes, dependent: :destroy

  scope :recent, -> { order('id DESC') }
  scope :of_issue, ->(issue) { where(issue: issue) }
  scope :of_quote, ->(quote) { where(quote: quote) }
  scope :of_agent, ->(agent) { where(agent: agent) }
  scope :of_theme, ->(theme) { where(issue_id: Issue.where(agenda_theme_id: theme.id)) }

  def has_content?
    quote.present? or body.present?
  end

  def stance_text_by_theme
    Opinion.stance_text_by_theme self.issue.agenda_theme, self.stance
  end

  def stance_long_text_by_theme
    Opinion.stance_long_text_by_theme self.issue.agenda_theme, self.stance
  end

  def self.available_stance_values_by_theme agenda_theme
    if agenda_theme.try(:slug) == 'votefuture'
      Opinion.stance.values.reject { |v| v == 'disagree'}
    else
      Opinion.stance.values
    end
  end

  def self.stance_text_by_theme agenda_theme, stance
    I18n.t("enumerize.#{agenda_theme.try(:slug) || 'default'}.stance.#{stance}", default: I18n.t("enumerize.defaults.stance.#{stance}"))
  end

  def self.stance_long_text_by_theme agenda_theme, stance
    I18n.t("enumerize.#{agenda_theme.try(:slug) || 'default'}.stance.long.#{stance}", default: I18n.t("enumerize.defaults.stance.long.#{stance}"))
  end
end
