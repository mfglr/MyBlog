module CommentsHelper
    def get_comment_header_color(comment)
        if comment.article.user == current_user
            comment.approved? ? "bg-success" : comment.pending? ? "bg-warning" : "bg-danger"
        else
            return "" if comment.user != current_user
            comment.approved? ? "bg-success" : comment.pending? ? "bg-warning" : "bg-danger"
        end
    end

    def is_approvable?(comment)
        comment.article.user == current_user && comment.pending?
    end

    def is_manipulated?(comment)
        comment.user == current_user && comment.pending?
    end
end
