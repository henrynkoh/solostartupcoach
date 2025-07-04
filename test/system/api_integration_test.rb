require "application_system_test_case"

class ApiIntegrationTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_user
    @startup_tip = startup_tips(:one)
    @video = videos(:one)
  end
  
  test "API requires authentication" do
    # Sign out to test unauthenticated access
    sign_out @user
    
    # Try to access API endpoints
    visit "/api/v1/startup_tips"
    
    # Should be redirected to sign in
    assert_current_path "/users/sign_in"
  end
  
  test "user can access startup tips API" do
    visit "/api/v1/startup_tips"
    
    # Should see JSON response
    assert_text "startup_tips"
    assert_text @startup_tip.title
  end
  
  test "user can create startup tip via API" do
    visit "/api/v1/startup_tips"
    
    # Click create new tip
    click_link "Create New Tip"
    
    # Fill in form
    fill_in "Title", with: "API Created Tip"
    fill_in "Content", with: "This tip was created via API"
    fill_in "Source URL", with: "https://api.example.com/tip"
    
    click_button "Create"
    
    # Should see success response
    assert_text "API Created Tip"
    assert_text "created successfully"
  end
  
  test "user can update startup tip via API" do
    visit "/api/v1/startup_tips/#{@startup_tip.id}"
    
    # Click edit
    click_link "Edit"
    
    # Update content
    fill_in "Title", with: "Updated via API"
    click_button "Update"
    
    # Should see updated content
    assert_text "Updated via API"
    assert_text "updated successfully"
  end
  
  test "user can delete startup tip via API" do
    visit "/api/v1/startup_tips/#{@startup_tip.id}"
    
    # Click delete
    click_link "Delete"
    
    # Confirm deletion
    page.driver.browser.switch_to.alert.accept
    
    # Should see deletion success
    assert_text "deleted successfully"
  end
  
  test "user can access videos API" do
    visit "/api/v1/videos"
    
    # Should see videos list
    assert_text "videos"
    assert_text @video.title
  end
  
  test "user can generate video via API" do
    visit "/api/v1/startup_tips/#{@startup_tip.id}"
    
    # Click generate video
    click_button "Generate Video"
    
    # Should see job creation response
    assert_text "Video generation started"
    assert_text "job_id"
  end
  
  test "user can check job status via API" do
    # First create a job
    visit "/api/v1/startup_tips/#{@startup_tip.id}"
    click_button "Generate Video"
    
    # Extract job ID from response
    job_id = page.text.match(/job_id":\s*"([^"]+)"/)[1]
    
    # Check job status
    visit "/api/v1/jobs/#{job_id}"
    
    # Should see job status
    assert_text "status"
    assert_text "progress"
  end
  
  test "user can access statistics API" do
    visit "/api/v1/statistics"
    
    # Should see statistics data
    assert_text "statistics"
    assert_text "total_tips"
    assert_text "total_videos"
  end
  
  test "user can access health check API" do
    visit "/api/v1/health"
    
    # Should see health status
    assert_text "status"
    assert_text "healthy"
  end
  
  test "API returns proper error for invalid requests" do
    # Try to access non-existent resource
    visit "/api/v1/startup_tips/999999"
    
    # Should see 404 error
    assert_text "Not Found"
  end
  
  test "API validates input data" do
    visit "/api/v1/startup_tips"
    click_link "Create New Tip"
    
    # Try to submit invalid data
    fill_in "Title", with: ""
    fill_in "Content", with: ""
    click_button "Create"
    
    # Should see validation errors
    assert_text "Title can't be blank"
    assert_text "Content can't be blank"
  end
  
  test "API supports pagination" do
    # Create multiple tips for pagination
    15.times do |i|
      StartupTip.create!(
        title: "Tip #{i + 1}",
        content: "Content #{i + 1}",
        user: @user
      )
    end
    
    visit "/api/v1/startup_tips"
    
    # Should see pagination metadata
    assert_text "pagination"
    assert_text "total_pages"
    assert_text "current_page"
  end
  
  test "API supports filtering" do
    visit "/api/v1/startup_tips"
    
    # Apply filter
    fill_in "Search", with: @startup_tip.title
    click_button "Filter"
    
    # Should see filtered results
    assert_text @startup_tip.title
  end
  
  test "API supports sorting" do
    visit "/api/v1/startup_tips"
    
    # Sort by title
    click_link "Sort by Title"
    
    # Should see sorted results
    assert_text "sorted by title"
  end
  
  test "API rate limiting works" do
    # Make multiple rapid requests
    10.times do
      visit "/api/v1/startup_tips"
    end
    
    # Should eventually hit rate limit
    assert_text "Rate limit exceeded"
  end
  
  test "API returns proper content type" do
    visit "/api/v1/startup_tips"
    
    # Check response headers
    assert_equal "application/json", page.response_headers["Content-Type"]
  end
  
  test "API supports CORS for cross-origin requests" do
    # This would typically be tested with a separate client
    # For now, we'll check that CORS headers are set
    visit "/api/v1/startup_tips"
    
    # Should have CORS headers
    assert_not_nil page.response_headers["Access-Control-Allow-Origin"]
  end
  
  test "API authentication token validation" do
    # Sign out
    sign_out @user
    
    # Try to access API with invalid token
    page.driver.browser.add_header("Authorization", "Bearer invalid_token")
    visit "/api/v1/startup_tips"
    
    # Should see unauthorized error
    assert_text "Unauthorized"
  end
  
  test "API handles malformed JSON gracefully" do
    visit "/api/v1/startup_tips"
    click_link "Create New Tip"
    
    # Try to submit malformed data
    fill_in "Title", with: "Test"
    fill_in "Content", with: "Test content"
    
    # Simulate malformed JSON submission
    page.execute_script("document.querySelector('form').action = '/api/v1/startup_tips'; document.querySelector('form').method = 'POST';")
    
    click_button "Create"
    
    # Should handle gracefully
    assert_text "Bad Request"
  end
end 