require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module FinalCase
  class Application < Rails::Application
    config.load_defaults 7.1
    config.i18n.default_locale = :tr
    config.autoload_lib(ignore: %w(assets tasks))
  end
end
