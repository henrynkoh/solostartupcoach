require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
    @video = videos(:one)
  end

  test "should be valid with all required attributes" do
    assert @video.valid?
  end

  test "title should be present" do
    @video.title = nil
    assert_not @video.valid?
    assert_includes @video.errors[:title], "can't be blank"
  end

  test "description should be present" do
    @video.description = nil
    assert_not @video.valid?
    assert_includes @video.errors[:description], "can't be blank"
  end

  test "file_path should be present" do
    @video.file_path = nil
    assert_not @video.valid?
    assert_includes @video.errors[:file_path], "can't be blank"
  end

  test "status should be included in allowed statuses" do
    @video.status = "invalid_status"
    assert_not @video.valid?
    assert_includes @video.errors[:status], "is not included in the list"
  end

  test "youtube_url should be a valid URL if present" do
    @video.youtube_url = "not_a_url"
    assert_not @video.valid?
    assert_includes @video.errors[:youtube_url], "is not a valid URL"

    @video.youtube_url = "https://youtube.com/watch?v=abc123"
    assert @video.valid?
  end

  test "should validate file_size is within limits" do
    @video.file_size = Video::MAX_FILE_SIZE + 1
    assert_not @video.valid?
    assert_includes @video.errors[:file_size], "must be less than #{Video::MAX_FILE_SIZE} bytes"

    @video.file_size = Video::MAX_FILE_SIZE - 1
    assert @video.valid?
  end

  test "duration should be a positive integer if present" do
    @video.duration = -1
    assert_not @video.valid?
    assert_includes @video.errors[:duration], "must be greater than 0"

    @video.duration = 0
    assert_not @video.valid?
    assert_includes @video.errors[:duration], "must be greater than 0"

    @video.duration = 300
    assert @video.valid?
  end
end
