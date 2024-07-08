require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @mike = users(:mike)
    @ddd = tags(:tdd)
    @tdd = tags(:tdd)
    @draft_article = articles(:draft_article)
    @published_article = articles(:published_article)
  end

  test "should not save article when title is empty" do
    article = Article.new
    
    assert_not @mike.articles << article
  end

  test "should not save article when title is longer than 140 characters" do
    title = "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567891"
    article = Article.new(title: title)
    
    assert_not @mike.articles << article
  end

  test "should be true when article is successfully created" do
    published = true
    title = "This is my first article"
    content = "A basic content"
    tags = [ @tdd, @ddd ]

    article = Article.new(published: published,title: title,content: content,tags: tags)

    assert @mike.articles << article
    assert_equal published, article.published 
    assert_equal title, article.title 
    assert_equal content, article.content.to_plain_text 
    assert article.article_likes.empty?
    assert article.comments.empty?
    assert article.tags.length == 2
    assert article.tags.first.name == @tdd.name
    assert article.tags.last.name == @ddd.name
  end

  test "should be draft article by default" do
    title = "title"
    article = Article.new(title: title)

    assert @mike.articles << article
    assert_not article.published
  end

  test "should be true published when article is successfully published" do
    assert @draft_article.publish
    assert @draft_article.published
  end

  test "should be false published when aticle is successfully unpublished" do
    assert @published_article.unpublish
    assert_not @published_article.published
  end

  test "should be true published when article is already published" do
    assert @published_article.publish
    assert @published_article.published
  end

  test "should be false published when article is already unpublished" do
    assert @draft_article.unpublish
    assert_not @draft_article.published
  end
end
