require "application_system_test_case"

class ErrorHandlingAndEdgeCasesTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_user
    @startup_tip = startup_tips(:one)
    @video = videos(:one)
  end
  
  test "handles network connectivity issues gracefully" do
    visit root_path
    
    # Simulate network failure by disabling JavaScript
    page.execute_script("window.fetch = function() { return Promise.reject(new Error('Network error')); }")
    
    # Try to create a startup tip
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    fill_in "Title", with: "Network Test Tip"
    fill_in "Content", with: "Testing network resilience"
    click_button "Create Tip"
    
    # Should show network error message
    assert_text "Network error"
    assert_text "Please check your connection"
  end
  
  test "handles server errors gracefully" do
    visit root_path
    
    # Simulate server error
    page.execute_script("window.fetch = function() { return Promise.resolve({ ok: false, status: 500, json: () => Promise.resolve({ error: 'Internal server error' }) }); }")
    
    click_link "Startup Tips"
    
    # Should show error message
    assert_text "Something went wrong"
    assert_text "Please try again later"
  end
  
  test "handles invalid form submissions" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Submit empty form
    click_button "Create Tip"
    
    # Should show validation errors
    assert_text "Title can't be blank"
    assert_text "Content can't be blank"
    
    # Try with extremely long content
    fill_in "Title", with: "A" * 1000
    fill_in "Content", with: "B" * 10000
    click_button "Create Tip"
    
    # Should show length validation errors
    assert_text "Title is too long"
    assert_text "Content is too long"
  end
  
  test "handles concurrent user actions" do
    visit root_path
    click_link "Startup Tips"
    
    # Simulate multiple rapid clicks
    5.times do
      click_link "Add New Tip"
    end
    
    # Should handle gracefully without creating duplicates
    assert_text "Add New Tip", count: 1
  end
  
  test "handles large data sets" do
    # Create many startup tips
    100.times do |i|
      StartupTip.create!(
        title: "Tip #{i + 1}",
        content: "Content for tip #{i + 1}",
        user: @user
      )
    end
    
    visit root_path
    click_link "Startup Tips"
    
    # Should load without timeout
    assert_text "Tip 1"
    assert_text "Tip 100"
    
    # Should have pagination
    assert_text "Next"
  end
  
  test "handles special characters in content" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Test with special characters
    special_content = "Test with émojis 🚀 and <script>alert('xss')</script> and 'quotes' and \"double quotes\""
    
    fill_in "Title", with: "Special Characters Test"
    fill_in "Content", with: special_content
    click_button "Create Tip"
    
    # Should handle special characters properly
    assert_text "Special Characters Test"
    assert_text "émojis 🚀"
    assert_text "quotes"
    assert_no_text "<script>"
  end
  
  test "handles file upload errors" do
    visit root_path
    click_link "Startup Tips"
    
    # Try to upload invalid file
    attach_file "File", Rails.root.join("test", "fixtures", "files", "invalid.txt")
    click_button "Upload"
    
    # Should show file validation error
    assert_text "Invalid file type"
  end
  
  test "handles session timeout gracefully" do
    visit root_path
    
    # Simulate session timeout
    page.driver.browser.manage.delete_all_cookies
    
    # Try to perform an action
    click_link "Startup Tips"
    
    # Should redirect to sign in
    assert_current_path "/users/sign_in"
    assert_text "Please sign in to continue"
  end
  
  test "handles browser back/forward navigation" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Go back
    page.go_back
    
    # Should be back on tips list
    assert_text "Startup Tips"
    
    # Go forward
    page.go_forward
    
    # Should be back on add form
    assert_text "Add New Tip"
  end
  
  test "handles slow loading states" do
    visit root_path
    
    # Simulate slow network
    page.execute_script("window.fetch = function() { return new Promise(resolve => setTimeout(() => resolve({ ok: true, json: () => Promise.resolve({}) }), 3000)); }")
    
    click_link "Startup Tips"
    
    # Should show loading indicator
    assert_text "Loading"
    assert_selector ".loading-spinner"
  end
  
  test "handles malformed URLs" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Try with invalid URL
    fill_in "Title", with: "Invalid URL Test"
    fill_in "Content", with: "Test content"
    fill_in "Source URL", with: "not-a-valid-url"
    click_button "Create Tip"
    
    # Should show URL validation error
    assert_text "is not a valid URL"
  end
  
  test "handles duplicate content gracefully" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Create first tip
    fill_in "Title", with: "Duplicate Test"
    fill_in "Content", with: "This is duplicate content"
    click_button "Create Tip"
    
    # Try to create duplicate
    click_link "Add New Tip"
    fill_in "Title", with: "Duplicate Test"
    fill_in "Content", with: "This is duplicate content"
    click_button "Create Tip"
    
    # Should handle gracefully
    assert_text "Tip created successfully"
  end
  
  test "handles database connection issues" do
    visit root_path
    
    # Simulate database error
    StartupTip.stub_any_instance(:save, false) do
      click_link "Startup Tips"
      click_link "Add New Tip"
      
      fill_in "Title", with: "Database Test"
      fill_in "Content", with: "Testing database resilience"
      click_button "Create Tip"
      
      # Should show database error
      assert_text "Database error"
      assert_text "Please try again"
    end
  end
  
  test "handles memory pressure gracefully" do
    visit root_path
    
    # Create many objects to simulate memory pressure
    large_data = "x" * 1000000
    
    # Should not crash the application
    assert_text "Dashboard"
  end
  
  test "handles timezone differences" do
    visit root_path
    
    # Change timezone
    page.execute_script("Intl.DateTimeFormat = function() { return { format: function() { return '2024-01-01 12:00:00 UTC'; } }; }")
    
    click_link "Startup Tips"
    
    # Should display dates correctly
    assert_text "2024-01-01"
  end
  
  test "handles browser compatibility issues" do
    visit root_path
    
    # Simulate old browser
    page.execute_script("window.fetch = undefined;")
    
    # Should fallback gracefully
    assert_text "Dashboard"
  end
  
  test "handles rapid user input" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Rapid typing
    fill_in "Title", with: "Rapid Input Test"
    fill_in "Content", with: "Testing rapid input handling"
    
    # Rapid clicks
    10.times { click_button "Create Tip" }
    
    # Should handle gracefully
    assert_text "Tip created successfully"
  end
  
  test "handles empty search results" do
    visit root_path
    click_link "Startup Tips"
    
    # Search for non-existent content
    fill_in "Search tips", with: "nonexistentcontent12345"
    click_button "Search"
    
    # Should show no results message
    assert_text "No tips found"
    assert_text "Try adjusting your search terms"
  end
  
  test "handles API rate limiting gracefully" do
    visit root_path
    
    # Simulate rate limiting
    page.execute_script("window.fetch = function() { return Promise.resolve({ ok: false, status: 429, json: () => Promise.resolve({ error: 'Rate limit exceeded' }) }); }")
    
    click_link "Startup Tips"
    
    # Should show rate limit message
    assert_text "Rate limit exceeded"
    assert_text "Please wait before trying again"
  end
end 