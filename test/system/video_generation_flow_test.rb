require "application_system_test_case"

class VideoGenerationFlowTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_user
    @startup_tip = startup_tips(:one)
    @video = videos(:one)
  end
  
  test "user can generate video from startup tip" do
    visit root_path
    click_link "Startup Tips"
    
    # Find the tip and generate video
    within "#startup-tip-#{@startup_tip.id}" do
      click_button "Generate Video"
    end
    
    # Should see job creation success
    assert_text "Video generation started"
    assert_text "Job ID:"
    
    # Should be redirected to job status or videos page
    assert_current_path "/videos"
  end
  
  test "user can view video generation status" do
    visit root_path
    click_link "Videos"
    
    # Should see videos list with status
    assert_text "Videos"
    assert_text @video.title
    assert_text @video.status
  end
  
  test "user can track job progress" do
    visit root_path
    click_link "Jobs"
    
    # Should see jobs list
    assert_text "Background Jobs"
    
    # Click on a job to view details
    click_link "View Details"
    
    # Should see job status and progress
    assert_text "Status:"
    assert_text "Progress:"
  end
  
  test "user can retry failed video generation" do
    # Create a failed video
    failed_video = Video.create!(
      title: "Failed Video",
      description: "A video that failed to generate",
      status: "failed",
      user: @user,
      startup_tip: @startup_tip
    )
    
    visit root_path
    click_link "Videos"
    
    # Find the failed video and retry
    within "#video-#{failed_video.id}" do
      click_button "Retry"
    end
    
    # Should see retry success message
    assert_text "Video generation restarted"
  end
  
  test "user can cancel running job" do
    visit root_path
    click_link "Jobs"
    
    # Find a running job and cancel it
    within ".job-item" do
      click_button "Cancel"
    end
    
    # Should see cancellation success
    assert_text "Job cancelled successfully"
  end
  
  test "user can view video details" do
    visit root_path
    click_link "Videos"
    
    # Click on a video to view details
    click_link @video.title
    
    # Should see video details
    assert_text @video.title
    assert_text @video.description
    assert_text @video.status
  end
  
  test "user can edit video metadata" do
    visit root_path
    click_link "Videos"
    
    # Find and edit a video
    within "#video-#{@video.id}" do
      click_link "Edit"
    end
    
    # Update video information
    fill_in "Title", with: "Updated Video Title"
    fill_in "Description", with: "Updated video description"
    
    click_button "Update Video"
    
    # Should see updated content
    assert_text "Video was successfully updated"
    assert_text "Updated Video Title"
  end
  
  test "user can delete video" do
    visit root_path
    click_link "Videos"
    
    # Find and delete a video
    within "#video-#{@video.id}" do
      click_link "Delete"
    end
    
    # Confirm deletion
    page.driver.browser.switch_to.alert.accept
    
    # Should see deletion success
    assert_text "Video was successfully deleted"
    assert_no_text @video.title
  end
  
  test "user can filter videos by status" do
    visit root_path
    click_link "Videos"
    
    # Filter by processing status
    select "Processing", from: "Status filter"
    click_button "Filter"
    
    # Should see filtered results
    assert_text "Filtered by: Processing"
  end
  
  test "user can search videos" do
    visit root_path
    click_link "Videos"
    
    # Search for a specific video
    fill_in "Search videos", with: @video.title
    click_button "Search"
    
    # Should see matching results
    assert_text @video.title
  end
  
  test "user can upload video to YouTube" do
    # Create a completed video
    completed_video = Video.create!(
      title: "Completed Video",
      description: "A video ready for upload",
      status: "processing",
      user: @user,
      startup_tip: @startup_tip
    )
    
    visit root_path
    click_link "Videos"
    
    # Find and upload the video
    within "#video-#{completed_video.id}" do
      click_button "Upload to YouTube"
    end
    
    # Should see upload success
    assert_text "Video upload started"
  end
  
  test "user can view video generation queue" do
    visit root_path
    click_link "Jobs"
    
    # Should see queue information
    assert_text "Queue Status"
    assert_text "Pending Jobs"
    assert_text "Running Jobs"
  end
  
  test "user can view video statistics" do
    visit root_path
    click_link "Dashboard"
    
    # Should see video statistics
    assert_text "Videos Generated"
    assert_text "Videos Uploaded"
    assert_text "Success Rate"
  end
  
  test "user can retry failed upload" do
    # Create a video with failed upload
    failed_upload_video = Video.create!(
      title: "Failed Upload Video",
      description: "A video that failed to upload",
      status: "failed",
      youtube_url: nil,
      user: @user,
      startup_tip: @startup_tip
    )
    
    visit root_path
    click_link "Videos"
    
    # Find and retry upload
    within "#video-#{failed_upload_video.id}" do
      click_button "Retry Upload"
    end
    
    # Should see retry success
    assert_text "Upload restarted"
  end
  
  test "user can view video generation logs" do
    visit root_path
    click_link "Jobs"
    
    # Click on a job to view logs
    click_link "View Logs"
    
    # Should see job logs
    assert_text "Job Logs"
    assert_text "Started at:"
    assert_text "Completed at:"
  end
end 