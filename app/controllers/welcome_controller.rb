class WelcomeController < ApplicationController
    def index
        @articles = Article.published_articles
    end
end
