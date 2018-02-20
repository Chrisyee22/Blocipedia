class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save { self.role ||= :standard }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy
  has_many :collaborators
  has_many :collaborations, through: :collaborators, source: :wiki
  enum role: [:standard, :premium, :admin]

  attr_accessor :login

   validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

   def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end
end
