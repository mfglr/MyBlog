class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_article, only: %i[create update destroy edit mark_as_approved mark_as_rejected]
    before_action :find_comment, only: %i[update destroy edit mark_as_approved mark_as_rejected]
    before_action :reject_request_if_user_of_comment_is_not_current_user, only: %i[update destroy edit]
    before_action :reject_request_if_status_of_comment_is_not_pending, only: %i[edit update destroy]
    before_action :reject_request_if_current_user_is_not_owner_of_comments_article, only: %i[mark_as_approved mark_as_rejected]
    before_action :reject_request_if_comment_status_is_not_pending, only: %i[mark_as_approved mark_as_rejected]
    after_action :set_status, only: %i[create]
    
    def create
        @comment = current_user.comments.build(comment_params)
        if @article.comments << @comment
            redirect_to @article, notice: t("comment_notifications.create")
        else
            redirect_to @article, alert: t("comment_notifications.create_failed")
        end
    end

    def update
        if @comment.update(comment_params)
            redirect_to request.referer, notice: t("comment_notifications.update")
        else
            redirect_to request.referer, alert: t("comment_notifications.update_failed")
        end
    end

    def destroy
        if @comment.destroy
            redirect_to request.referer, notice: t("comment_notifications.destroy")
        else
            redirect_to request.referer, alert: t("comment_notifications.destroy_failed")
        end
    end
    
    def edit; end

    def mark_as_approved
        if @comment.approved!
            redirect_to request.referer, notice: t("comment_notifications.mark_as_approved")
        else
            redirect_to request.referer, alert: t("comment_notifications.mark_as_approved_failed")
        end
    end

    def mark_as_rejected
        if @comment.rejected!
            redirect_to request.referer, notice: t("comment_notifications.mark_as_rejected")
        else
            redirect_to request.referer, alert: t("comment_notifications.mark_as_rejected_failed")
        end
    end
    
    private
        def comment_params
            params.require(:comment).permit(:body)
        end

        def find_article
            @article = Article.find(params[:article_id])
        end
 
        def find_comment
            @comment = @article.comments.find(params[:id])
        end

        def reject_request_if_user_of_comment_is_not_current_user
            if @comment.user != current_user
                redirect_to my_pending_comments_profile_index_path, alert: t("comment_notifications.owner")
            end
        end

        def reject_request_if_status_of_comment_is_not_pending
            unless @comment.pending?
                redirect_to my_pending_comments_profile_index_path, alert: t("comment_notifications.not_pending_comment_manipulate")
            end
        end

        def reject_request_if_current_user_is_not_owner_of_comments_article
            unless current_user.articles.include?(@comment.article)
                redirect_to my_received_pending_comments_profile_index_path, alert: t("comment_notifications.belong_article")
            end
        end

        def reject_request_if_comment_status_is_not_pending
            unless @comment.pending?
                redirect_to my_received_pending_comments_profile_index_path, alert: t("comment_notifications.not_pending_status_manipulate")
            end
        end

        def set_status
            if @article.user == @comment.user
                @comment.approved!
            else
                @comment.pending!
            end
        end
end
