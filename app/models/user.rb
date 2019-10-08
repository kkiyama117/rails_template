# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google]

  # name validates
  validates :first_name, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }
  validates :last_name, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }

  # auth model
  has_many :o_auths, dependent: :delete_all
  accepts_nested_attributes_for :o_auths, allow_destroy: true, reject_if: :all_blank

  scope :with_auth, -> { joins(:o_auths) }
  scope :find_by_auth, lambda { |auth|
    with_auth.merge(OAuth.where(provider: auth.provider, uid: auth.uid))
  }
end
