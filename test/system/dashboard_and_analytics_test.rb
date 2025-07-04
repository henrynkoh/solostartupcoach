require "application_system_test_case"

class DashboardAndAnalyticsTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_user
    @startup_tip = startup_tips(:one)
    @video = videos(:one)
  end
  
  test "user can view dashboard with statistics" do
    visit root_path
    
    # Should see dashboard overview
    assert_text "Dashboard"
    assert_text "Welcome back"
    
    # Should see key statistics
    assert_text "Total Startup Tips"
    assert_text "Videos Generated"
    assert_text "Success Rate"
    assert_text "Recent Activity"
  end
  
  test "user can view startup tips statistics" do
    visit root_path
    
    # Navigate to statistics section
    click_link "Statistics"
    
    # Should see tips statistics
    assert_text "Startup Tips Analytics"
    assert_text "Total Tips"
    assert_text "Tips by Sentiment"
    assert_text "Tips by Month"
  end
  
  test "user can view video generation statistics" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to video statistics
    click_link "Video Analytics"
    
    # Should see video statistics
    assert_text "Video Generation Stats"
    assert_text "Videos Generated"
    assert_text "Upload Success Rate"
    assert_text "Average Generation Time"
  end
  
  test "user can view performance metrics" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to performance metrics
    click_link "Performance"
    
    # Should see performance data
    assert_text "System Performance"
    assert_text "Job Queue Status"
    assert_text "Average Response Time"
    assert_text "Error Rate"
  end
  
  test "user can view activity timeline" do
    visit root_path
    
    # Should see recent activity
    assert_text "Recent Activity"
    
    # Should see activity items
    assert_text "Created startup tip"
    assert_text "Generated video"
  end
  
  test "user can export statistics" do
    visit root_path
    click_link "Statistics"
    
    # Click export button
    click_button "Export Data"
    
    # Should see export options
    assert_text "Export Options"
    assert_text "CSV"
    assert_text "JSON"
  end
  
  test "user can filter dashboard data by date range" do
    visit root_path
    
    # Set date range filter
    fill_in "Start date", with: "2024-01-01"
    fill_in "End date", with: "2024-12-31"
    click_button "Apply Filter"
    
    # Should see filtered data
    assert_text "Filtered by date range"
  end
  
  test "user can view sentiment analysis charts" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to sentiment analysis
    click_link "Sentiment Analysis"
    
    # Should see sentiment charts
    assert_text "Sentiment Distribution"
    assert_text "Positive Tips"
    assert_text "Negative Tips"
    assert_text "Neutral Tips"
  end
  
  test "user can view content quality metrics" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to content quality
    click_link "Content Quality"
    
    # Should see quality metrics
    assert_text "Content Quality Metrics"
    assert_text "Average Tip Length"
    assert_text "Most Popular Topics"
    assert_text "Engagement Rate"
  end
  
  test "user can view system health status" do
    visit root_path
    
    # Should see system status
    assert_text "System Status"
    assert_text "All systems operational"
    
    # Check individual service status
    assert_text "Database"
    assert_text "Redis"
    assert_text "Sidekiq"
  end
  
  test "user can view user activity heatmap" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to activity heatmap
    click_link "Activity Heatmap"
    
    # Should see activity visualization
    assert_text "Activity Heatmap"
    assert_text "Most Active Hours"
    assert_text "Weekly Pattern"
  end
  
  test "user can view error logs and alerts" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to error logs
    click_link "Error Logs"
    
    # Should see error information
    assert_text "Error Logs"
    assert_text "Recent Errors"
    assert_text "Error Rate"
  end
  
  test "user can view job queue monitoring" do
    visit root_path
    click_link "Jobs"
    
    # Should see queue monitoring
    assert_text "Queue Monitoring"
    assert_text "Pending Jobs"
    assert_text "Running Jobs"
    assert_text "Failed Jobs"
  end
  
  test "user can view API usage statistics" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to API usage
    click_link "API Usage"
    
    # Should see API statistics
    assert_text "API Usage Statistics"
    assert_text "Requests per Day"
    assert_text "Response Times"
    assert_text "Error Rates"
  end
  
  test "user can view storage usage" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to storage
    click_link "Storage"
    
    # Should see storage information
    assert_text "Storage Usage"
    assert_text "Video Storage"
    assert_text "Database Size"
    assert_text "Available Space"
  end
  
  test "user can refresh dashboard data" do
    visit root_path
    
    # Click refresh button
    click_button "Refresh"
    
    # Should see updated data
    assert_text "Data refreshed"
  end
  
  test "user can view personalized recommendations" do
    visit root_path
    
    # Should see recommendations section
    assert_text "Recommendations"
    assert_text "Suggested Tips"
    assert_text "Popular Topics"
  end
  
  test "user can view comparison charts" do
    visit root_path
    click_link "Statistics"
    
    # Navigate to comparisons
    click_link "Comparisons"
    
    # Should see comparison data
    assert_text "Month over Month"
    assert_text "Week over Week"
    assert_text "Performance Trends"
  end
end 