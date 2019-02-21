require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyBill
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Sydney'
    config.i18n.default_locale = :'zh-CN'
  end
end
