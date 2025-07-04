require "application_system_test_case"

class AuthenticationFlowTest < ApplicationSystemTestCase
  test "user can sign up with valid credentials" do
    visit root_path
    
    # Should redirect to sign in page when not authenticated
    assert_current_path "/users/sign_in"
    
    # Click sign up link
    click_link "Sign up"
    assert_current_path "/users/sign_up"
    
    # Fill in sign up form
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "SecurePassword123!"
    fill_in "Password confirmation", with: "SecurePassword123!"
    
    # Submit form
    click_button "Sign up"
    
    # Should be redirected to root and signed in
    assert_current_path "/"
    assert_text "Welcome! You have signed up successfully."
  end
  
  test "user cannot sign up with invalid password" do
    visit "/users/sign_up"
    
    # Try with weak password
    fill_in "Email", with: "weakuser@example.com"
    fill_in "Password", with: "weak"
    fill_in "Password confirmation", with: "weak"
    
    click_button "Sign up"
    
    # Should show validation errors
    assert_text "Password is too short"
    assert_text "must include at least one uppercase letter"
  end
  
  test "user can sign in with valid credentials" do
    user = users(:one)
    
    visit "/users/sign_in"
    
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    
    click_button "Log in"
    
    # Should be signed in and redirected
    assert_current_path "/"
    assert_text "Signed in successfully."
  end
  
  test "user cannot sign in with invalid credentials" do
    visit "/users/sign_in"
    
    fill_in "Email", with: "nonexistent@example.com"
    fill_in "Password", with: "wrongpassword"
    
    click_button "Log in"
    
    # Should show error message
    assert_text "Invalid email or password."
  end
  
  test "user can sign out" do
    user = sign_in_user
    
    visit root_path
    
    # Should be on dashboard
    assert_text "Dashboard"
    
    # Sign out
    click_link "Sign out"
    
    # Should be redirected to sign in page
    assert_current_path "/users/sign_in"
    assert_text "Signed out successfully."
  end
  
  test "unauthenticated user is redirected to sign in" do
    visit root_path
    
    # Should be redirected to sign in
    assert_current_path "/users/sign_in"
    assert_text "You need to sign in or sign up before continuing."
  end
  
  test "user session times out after inactivity" do
    user = sign_in_user
    
    # Simulate session timeout by clearing session
    page.driver.browser.manage.delete_all_cookies
    
    visit root_path
    
    # Should be redirected to sign in
    assert_current_path "/users/sign_in"
  end
  
  test "user account is locked after too many failed attempts" do
    user = users(:one)
    
    visit "/users/sign_in"
    
    # Try to sign in multiple times with wrong password
    6.times do
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"
    end
    
    # Account should be locked
    assert_text "Your account is locked."
  end
  
  test "password reset flow" do
    user = users(:one)
    
    visit "/users/sign_in"
    click_link "Forgot your password?"
    
    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"
    
    assert_text "You will receive an email with instructions"
  end
end 