module ArticlesHelper
    def format_article_content(article)
        return t("article.empty_content") if article.content.empty?
        return article.content.to_plain_text if article.content.to_plain_text.length <= 20
        "#{article.content.to_plain_text[0..19]}..."
    end

    def article_content(article)
        return t("article.empty_content") if article.content.empty?
        article.content
    end

    def format_article_title(article)
        return article.title if article.title.length <= 20
        "#{article.title[0..19]}..."
    end

    def get_article_header_background_color(article)
        return "" if current_user != article.user
        article.published ? "bg-success" : "bg-secondary"
    end

    def get_approved_comments_or_current_users_pending_comments(article)
        article.comments
            .where(status: :approved)
            .or(article.comments.where(user: current_user, status: :pending))
            .order(created_at: :desc)
    end

    def get_number_of_approved_comments_or_current_users_pending_comments(article)
        article.comments
            .where(status: :approved)
            .or(article.comments.where(user: current_user, status: :pending))
            .count
    end

    def is_liked?(article,user)
        ArticleLike.where(article_id: article.id, user_id: user.id).any?
    end
end
