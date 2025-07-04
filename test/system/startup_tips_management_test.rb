require "application_system_test_case"

class StartupTipsManagementTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_user
    @startup_tip = startup_tips(:one)
  end
  
  test "user can view startup tips list" do
    visit root_path
    
    # Navigate to startup tips
    click_link "Startup Tips"
    
    # Should see the tips list
    assert_text "Startup Tips"
    assert_text @startup_tip.title
    assert_text @startup_tip.content
  end
  
  test "user can create a new startup tip" do
    visit root_path
    click_link "Startup Tips"
    
    # Click create new tip button
    click_link "Add New Tip"
    
    # Fill in the form
    fill_in "Title", with: "Test Startup Tip"
    fill_in "Content", with: "This is a test startup tip content with valuable advice."
    fill_in "Source URL", with: "https://example.com/startup-advice"
    
    # Submit the form
    click_button "Create Tip"
    
    # Should see success message and new tip
    assert_text "Startup tip was successfully created"
    assert_text "Test Startup Tip"
    assert_text "This is a test startup tip content with valuable advice."
  end
  
  test "user cannot create tip with invalid data" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Try to submit empty form
    click_button "Create Tip"
    
    # Should see validation errors
    assert_text "Title can't be blank"
    assert_text "Content can't be blank"
  end
  
  test "user can edit an existing startup tip" do
    visit root_path
    click_link "Startup Tips"
    
    # Find and click edit button for the tip
    within "#startup-tip-#{@startup_tip.id}" do
      click_link "Edit"
    end
    
    # Update the tip
    fill_in "Title", with: "Updated Startup Tip"
    fill_in "Content", with: "Updated content with new advice."
    
    click_button "Update Tip"
    
    # Should see updated content
    assert_text "Startup tip was successfully updated"
    assert_text "Updated Startup Tip"
    assert_text "Updated content with new advice."
  end
  
  test "user can delete a startup tip" do
    visit root_path
    click_link "Startup Tips"
    
    # Find and click delete button
    within "#startup-tip-#{@startup_tip.id}" do
      click_link "Delete"
    end
    
    # Confirm deletion
    page.driver.browser.switch_to.alert.accept
    
    # Should see success message and tip should be gone
    assert_text "Startup tip was successfully deleted"
    assert_no_text @startup_tip.title
  end
  
  test "user can search startup tips" do
    visit root_path
    click_link "Startup Tips"
    
    # Search for a specific term
    fill_in "Search tips", with: @startup_tip.title
    click_button "Search"
    
    # Should see matching results
    assert_text @startup_tip.title
  end
  
  test "user can filter tips by sentiment" do
    visit root_path
    click_link "Startup Tips"
    
    # Filter by positive sentiment
    select "Positive", from: "Sentiment filter"
    click_button "Filter"
    
    # Should see filtered results
    assert_text "Filtered by: Positive"
  end
  
  test "user can view tip details" do
    visit root_path
    click_link "Startup Tips"
    
    # Click on a tip to view details
    click_link @startup_tip.title
    
    # Should see detailed view
    assert_text @startup_tip.title
    assert_text @startup_tip.content
    assert_text @startup_tip.source_url if @startup_tip.source_url.present?
  end
  
  test "user can generate video from startup tip" do
    visit root_path
    click_link "Startup Tips"
    
    # Find and click generate video button
    within "#startup-tip-#{@startup_tip.id}" do
      click_button "Generate Video"
    end
    
    # Should see success message and job status
    assert_text "Video generation started"
    assert_text "Job ID:"
  end
  
  test "content is sanitized when creating tip" do
    visit root_path
    click_link "Startup Tips"
    click_link "Add New Tip"
    
    # Try to add script content
    fill_in "Title", with: "Test Tip"
    fill_in "Content", with: "<script>alert('xss')</script>Valid content"
    click_button "Create Tip"
    
    # Should see sanitized content
    assert_text "Valid content"
    assert_no_text "<script>"
  end
  
  test "user can paginate through tips" do
    # Create multiple tips for pagination
    15.times do |i|
      StartupTip.create!(
        title: "Tip #{i + 1}",
        content: "Content for tip #{i + 1}",
        user: @user
      )
    end
    
    visit root_path
    click_link "Startup Tips"
    
    # Should see pagination controls
    assert_text "Next"
    
    # Click next page
    click_link "Next"
    
    # Should be on page 2
    assert_text "Previous"
  end
end 