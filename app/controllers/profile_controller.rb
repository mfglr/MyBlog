class ProfileController < ApplicationController
    before_action :authenticate_user!

    def my_published_articles
        @articles = current_user.articles.where(published: true).order(created_at: :desc)
    end

    def my_draft_articles
        @articles = current_user.articles.where(published: false).order(created_at: :desc)
    end

    def my_comments 
        @comments = current_user
            .comments
            .where.not(article_id: current_user.articles.pluck(:id))
            .order(created_at: :desc)
    end

    def my_approved_comments
        @comments = current_user
            .comments
            .where.not(article_id: current_user.articles.pluck(:id))
            .where(status: :approved)
            .order(created_at: :desc)
    end

    def my_rejected_comments
        @comments = current_user.comments.where(status: :rejected).order(created_at: :desc)
    end

    def my_pending_comments
        @comments = current_user.comments.where(status: :pending).order(created_at: :desc)
    end

    def my_received_comments
        @comments = Comment
            .where(article_id: current_user.articles.pluck(:id))
            .where.not(user_id: current_user.id)
            .order(created_at: :desc)
    end

    def my_received_approved_comments
        @comments = Comment
            .where(article_id: current_user.articles.pluck(:id))
            .where.not(user_id: current_user.id)
            .where(status: :approved)
            .order(created_at: :desc)
    end

    def my_received_rejected_comments
        @comments = Comment
            .where(article_id: current_user.articles.pluck(:id))
            .where(status: :rejected)
            .order(created_at: :desc)
    end

    def my_received_pending_comments
        @comments = Comment
            .where(article_id: current_user.articles.pluck(:id))
            .where(status: :pending)
            .order(created_at: :desc)
    end
end
