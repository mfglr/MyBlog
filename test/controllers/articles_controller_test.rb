require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @article = articles(:article)
    @johns_article = articles(:johns_article)
    @mikes_published_article = articles(:mikes_published_article)
    @mikes_draft_article = articles(:mikes_draft_article)
    @mike = users(:mike)
    @john = users(:john)
  end

  #show article test begin
  test "should show article" do
    get article_path(@article)
    
    assert_response :success
  end
  test "should redirect to 404 page when article is not found" do
    article = Article.new
    article.id = 45

    get article_path(article)

    assert_redirected_to "/404"
  end
  #show article test end

  #update article tests begin
  test "should not update article when user is not authenticated" do
    put article_path(@article)

    assert_response :redirect
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_match I18n.t("devise.failure.unauthenticated"), response.body
  end
  test "should not update article when the article is not found" do
    article = Article.new
    article.id = Article.count + 1

    sign_in @mike
    put article_path(article)
    
    assert_redirected_to "/404"
  end 
  test "should not updated article when the user of the article is not current user" do
    
    sign_in @john
    put article_path(@mikes_draft_article)
    
    assert_redirected_to article_path(@mikes_draft_article)
    follow_redirect!
    assert_match I18n.t("article_notifications.owner"), response.body
  end
  test "should not update article when the article is published" do
    sign_in @mike
    put article_path(@mikes_published_article)

    assert_redirected_to article_path(@mikes_published_article)
    follow_redirect!
    assert_match I18n.t("article_notifications.state"), response.body
  end
  test "should be true when the article is successfully updated" do
    published = true
    title = "Updated title"
    content = "Updated content"

    sign_in @mike
    put article_path(@mikes_draft_article), params: { id: @mikes_draft_article.id, article: { title: title, content: content, published: published } }
    article = Article.find(@mikes_draft_article.id)

    assert_redirected_to article_path(@mikes_draft_article)
    follow_redirect!
    assert_match I18n.t("article_notifications.update"), response.body
    assert_equal published, article.published
    assert_equal title, article.title
    assert_equal content, article.content.to_plain_text
  end
  #update article tests end

end
