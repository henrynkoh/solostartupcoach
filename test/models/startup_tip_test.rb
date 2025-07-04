require 'test_helper'

class StartupTipTest < ActiveSupport::TestCase
  def setup
    @startup_tip = startup_tips(:one)
  end

  test "should be valid with all required attributes" do
    assert @startup_tip.valid?
  end

  test "title should be present" do
    @startup_tip.title = nil
    assert_not @startup_tip.valid?
    assert_includes @startup_tip.errors[:title], "can't be blank"
  end

  test "content should be present" do
    @startup_tip.content = nil
    assert_not @startup_tip.valid?
    assert_includes @startup_tip.errors[:content], "can't be blank"
  end

  test "source_url should be a valid URL if present" do
    @startup_tip.source_url = "not_a_url"
    assert_not @startup_tip.valid?
    assert_includes @startup_tip.errors[:source_url], "is not a valid URL"

    @startup_tip.source_url = "https://example.com/startup-tips"
    assert @startup_tip.valid?
  end

  test "sentiment_score should be between -1 and 1" do
    @startup_tip.sentiment_score = -1.5
    assert_not @startup_tip.valid?
    assert_includes @startup_tip.errors[:sentiment_score], "must be between -1 and 1"

    @startup_tip.sentiment_score = 1.5
    assert_not @startup_tip.valid?
    assert_includes @startup_tip.errors[:sentiment_score], "must be between -1 and 1"

    @startup_tip.sentiment_score = 0.8
    assert @startup_tip.valid?
  end

  test "should sanitize content before validation" do
    @startup_tip.content = "<script>alert('xss')</script>Valid content"
    @startup_tip.valid?
    assert_equal "Valid content", @startup_tip.content
  end
end
