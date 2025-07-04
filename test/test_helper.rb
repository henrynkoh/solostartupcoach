ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# Configure system tests
class ActionDispatch::SystemTestCase
  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
  
  # Helper method to sign in a user
  def sign_in_user(user = users(:one))
    sign_in user
    user
  end
  
  # Helper method to create and sign in a new user
  def create_and_sign_in_user(email = "test@example.com", password = "Password123!")
    user = User.create!(
      email: email,
      password: password,
      password_confirmation: password
    )
    sign_in user
    user
  end
end 