class User < ApplicationRecord
  before_create :set_nick_name
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
          :validatable, :omniauthable, omniauth_providers: [:github]
  has_many :articles, dependent: :destroy
  has_many :comments
  validates :nick_name, uniqueness: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      user = User.create(email: data['email'], password: Devise.friendly_token[0,20] )
    end
    user
  end

  private
    def set_nick_name
      first_section_of_email = email.split("@")[0]
      self.nick_name = "#{first_section_of_email}#{SecureRandom.uuid.delete("-")}"
    end
end
