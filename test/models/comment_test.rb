require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = articles(:article)
  end

  test "should not save comment when body is empty" do
    comment = Comment.new
    assert_not @article.comments << comment
  end
end
