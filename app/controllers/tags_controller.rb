class TagsController < ApplicationController
    before_action :authenticate_user!, except: %i[articles]

    def create
        @tag = Tag.new(tag_params)
        if @tag.save
            redirect_to new_article_path, notice: "The tag has been successfully created."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def new
        @tag = Tag.new
    end

    def articles
        @tag = Tag.find(params[:id])
        @articles = @tag.articles.where(published: true).order(created_at: :desc)
    end

    private
        def tag_params
            params.require(:tag).permit(:name)
        end
end
