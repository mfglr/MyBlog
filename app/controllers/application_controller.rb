class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler
    before_action :set_locale
    protect_from_forgery with: :null_session

    private
        def set_locale
            I18n.locale = session[:locale] || I18n.default_locale
        end

        def record_not_found_handler
            redirect_to "/404"
        end

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:account_update, keys: [:nick_name])
        end

        def after_sign_out_path_for(resource_or_scope)
            root_path
        end
end
