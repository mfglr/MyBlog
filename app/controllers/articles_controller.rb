class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: %i[show likes search]
    before_action :find_article, only: %i[show like dislike likes publish unpublish update destroy edit]
    before_action :reject_request_if_current_user_is_not_owner_of_article, only: %i[publish unpublish update destroy edit]
    before_action :reject_request_if_article_is_published, only: %i[update destroy edit]

    def update
       if @article.update(articles_params)
            redirect_to @article, notice: t("article_notifications.update")
       else
            render :edit, status: :unprocessable_entity
        end
    end

    def create
        @article = Article.create(articles_params)
        if current_user.articles << @article
            redirect_to @article, notice: t("article_notifications.create")
        else
            render :new, status: :unprocessable_entity
        end
    end

    def new
        @article = Article.new
    end

    def edit; end

    def show
        raise ActiveRecord::RecordNotFound if !@article.published && @article.user != current_user
    end

    def destroy
        if @article.destroy
            redirect_to"/#{current_user.nick_name}", notice: t("article_notifications.destroy")
        else
            redirect_to @article, alert: t("article_notifications.destroy_failed")
        end
    end

    def publish
        if @article.publish
            redirect_to @article, notice: t("article_notifications.publish")
        else
            redirect_to @article, alert: t("article_notifications.publish_failed")
        end
    end

    def unpublish
        if @article.unpublish
            redirect_to @article, notice: t("article_notifications.unpublish")
        else
            redirect_to @article, notice:  t("article_notifications.unpublish_failed")
        end
    end

    def like
        @article.article_likes << ArticleLike.new(user_id: current_user.id)

        redirect_to @article
    end

    def dislike
        like = @article.article_likes.where(user_id: current_user.id).first
        @article.article_likes.destroy(like)
        
        redirect_to @article 
    end

    def likes; end

    def search
        key = "%#{params[:keyword]}%"

        if params[:just_tags] == "1"
            @articles = Article
                .joins(:tags)
                .where("tags.name LIKE ?", key)
                .where(published: true)
                .order(created_at: :desc)
                .distinct
        else
            @articles = Article
                .left_outer_joins(:rich_text_content, :tags)
                .where("title LIKE ? OR action_text_rich_texts.body LIKE ? OR tags.name LIKE ?", key, key, key)
                .where(published: true)
                .order(created_at: :desc)
                .distinct
        end
    end

    private
        def articles_params
            params.require(:article).permit(:title, :content, :published, tag_ids: [])
        end

        def find_article
            @article = Article.find(params[:id])
        end

        def reject_request_if_current_user_is_not_owner_of_article
            if @article.user != current_user
                redirect_to @article, 
                alert: t("article_notifications.owner")
            end
        end

        def reject_request_if_article_is_published
            if @article.published
                redirect_to @article, alert: t("article_notifications.state")
            end
        end
end
