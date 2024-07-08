module Api
    class ArticlesController < ApplicationController
        def show
            render json: Article.find_by(id: params[:id], published: true)
        end

        def index
            render json: Article.published_articles
        end
    end
end
