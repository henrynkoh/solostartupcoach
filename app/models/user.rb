# frozen_string_literal: true

# Represents a user in the system.
#
# @!attribute [r] id
#   @return [Integer] The unique identifier for the user
# @!attribute email
#   @return [String] The user's email address
# @!attribute encrypted_password
#   @return [String] The user's encrypted password
# @!attribute created_at
#   @return [Time] When this record was created
# @!attribute updated_at
#   @return [Time] When this record was last updated
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable

  # Constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Security settings
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password,
            presence: true,
            length: { minimum: 12 },
            format: {
              with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{12,}\z/,
              message: 'must include at least one uppercase letter, one lowercase letter, ' \
                       'one number, and one special character'
            },
            if: :password_required?

  # Session timeouts
  def timeout_in
    if admin?
      30.minutes
    else
      2.hours
    end
  end

  # Account lockout after failed attempts
  def lock_strategy_enabled?(_opts)
    true
  end

  def maximum_attempts
    5
  end

  def unlock_strategy_enabled?(_opts)
    true
  end

  def unlock_in
    2.hours
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def password_complexity
    return if password.blank?
    return if password.match?(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{12,}$/)

    errors.add :password,
               'must include at least one uppercase letter, one lowercase letter, one number, and one special character'
  end
end
