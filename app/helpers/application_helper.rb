module ApplicationHelper
    def sign_in_with(provider)
        return "#{provider} #{t('devise_links.sign_in_with')}" if I18n.locale == :tr
        "#{t('devise_links.sign_in_with')} #{provider} "
    end
end
