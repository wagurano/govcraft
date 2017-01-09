class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :recoverable,
         :omniauthable,
         :omniauth_providers => [:facebook, :twitter]

  # assiciations
  has_many :following_issues, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :thumbs, dependent: :destroy
  has_many :speeches, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participated_projects, through: :participations, source: :project

  # validations
  VALID_NICKNAME_REGEX = /\A[ㄱ-ㅎ가-힣a-z0-9_]+\z/i

  validates :nickname,
    presence: true,
    exclusion: { in: %w(app new edit index session login logout users admin all crew issue group project) },
    format: { with: VALID_NICKNAME_REGEX },
    uniqueness: { case_sensitive: false },
    length: { maximum: 20 }
  validate :nickname_exclude_pattern
  validates :email,
    presence: true,
    format: { with: Devise.email_regexp },
    uniqueness: {scope: [:provider]}
  validates :uid, uniqueness: {scope: [:provider]}
  validates :password,
    presence: true,
    confirmation: true,
    length: Devise.password_length,
    if: :password_required?

  validates_confirmation_of :password, if: :password_required?

  # filters
  before_save :downcase_nickname
  before_validation :strip_whitespace_nickname, only: :nickname
  before_save :set_uid

  # mount
  mount_uploader :image, UserImageUploader

  # scope
  default_scope { order('id DESC') }
  scope :not_someone, ->(someone) { where.not(id: someone.id) }

  # methods for devises/auth
  def self.parse_omniauth(data)
    {provider: data['provider'], uid: data['uid'], email: data['info']['email'], image: data['info']['image']}
  end

  def self.new_with_session(params, session)
    resource = super
    auth = session["devise.omniauth_data"]
    if auth.present?
      auth["email"] = params['email'] if params['email'].present?
      resource.assign_attributes(auth)
      resource.password = Devise.friendly_token[0,20]
      resource.confirmed_at = DateTime.now
      resource.remote_image_url = auth['image']
    else
      resource.provider = 'email'
    end
    resource
  end

  def self.find_for_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first
  end

  # the other methods

  def following?(issue)
    following_issues.exists?(issue: issue)
  end

  # email auth

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["provider = 'email' AND uid = :value", { :value => email.downcase }]).first
  end

  # for recovering the password for an account
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    unless conditions.has_key?(:confirmation_token)
      conditions.merge! provider: 'email'
    end
    where(conditions.to_h).first
  end

  private

  def set_uid
    self.uid = self.email if self.provider == 'email'
  end

  def downcase_nickname
    self.nickname = nickname.downcase
  end

  def nickname_exclude_pattern
    if (self.nickname =~ /\Aparti.*\z/i) and (self.nickname_was !~ /\Aparti.*\z/i)
      errors.add(:nickname, I18n.t('errors.messages.taken'))
    end
  end

  def strip_whitespace_nickname
    self.nickname = self.nickname.strip unless self.nickname.nil?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
