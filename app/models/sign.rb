class Sign < ApplicationRecord
  include Reportable

  belongs_to :user, optional: true
  belongs_to :petition, counter_cache: true

  validates :user, uniqueness: { scope: :petition }, if: 'user.present?'
  validate :signer_should_be_present_if_user_is_blank
  validates :signer_email, format: { with: Devise.email_regexp }, uniqueness: { scope: :petition }, if: 'signer_email.present?'

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }

  def user_image_url
    user.present? ? user.image.sm.url : ActionController::Base.helpers.asset_path('default-user.png')
  end

  def user_name
    user.present? ? user.nickname : signer_name
  end

  private

  def signer_should_be_present_if_user_is_blank
    if user.blank? and signer_name.blank?
      errors.add(:signer_name, I18n.t('activerecord.errors.models.sign.signer.blank'))
    end
  end
end
