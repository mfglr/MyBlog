class LanguageController < ApplicationController
    def change
        session[:locale] = params[:locale]
        redirect_back(fallback_location: root_path)
    end
end