class UsersController < ApplicationController
    def show
        if params[:nick_name] == current_user&.nick_name
            @user = current_user;
            @articles = current_user.articles.order(created_at: :desc)
        else
            @user = User.find_by!(nick_name: params[:nick_name])
            @articles = @user.articles.where(published: true).order(created_at: :desc)
        end
    end
end
