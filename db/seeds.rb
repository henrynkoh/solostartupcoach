# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# frozen_string_literal: true

# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'Admin123!@#$',
  password_confirmation: 'Admin123!@#$'
)

puts 'Created admin user'

# Create startup tips
startup_tips = [
  {
    title: 'Customer Development Strategy',
    content: 'Start with customer interviews to validate your business idea. Talk to at least 100 potential customers before building anything.',
    source_url: 'https://www.startupschool.org/curriculum/customer-development',
    sentiment_score: 0.8
  },
  {
    title: 'Lean Startup Methodology',
    content: 'Build-Measure-Learn feedback loop is essential for startups. Start with an MVP and iterate based on real customer feedback.',
    source_url: 'https://theleanstartup.com/principles',
    sentiment_score: 0.6
  },
  {
    title: 'Finding Product-Market Fit',
    content: 'Focus on solving a real problem that people are willing to pay for. Product-market fit means having a product that creates significant customer value.',
    source_url: 'https://www.ycombinator.com/library/5z-the-real-product-market-fit',
    sentiment_score: 0.7
  }
]

startup_tips.each do |tip|
  StartupTip.create!(tip)
end

puts 'Created startup tips'

# Create videos
videos = [
  {
    title: 'Customer Development Fundamentals',
    description: 'Learn the basics of customer development and how to validate your startup idea through customer interviews.',
    file_path: '/path/to/videos/customer-development.mp4',
    file_size: 15.megabytes,
    duration: 600, # 10 minutes
    status: 'processing',
    youtube_url: nil
  },
  {
    title: 'Lean Startup Methodology Explained',
    description: 'A comprehensive guide to implementing the Build-Measure-Learn feedback loop in your startup.',
    file_path: '/path/to/videos/lean-startup.mp4',
    file_size: 20.megabytes,
    duration: 900, # 15 minutes
    status: 'uploaded',
    youtube_url: 'https://youtube.com/watch?v=abc123'
  }
]

videos.each do |video|
  Video.create!(video)
end

puts 'Created videos'
