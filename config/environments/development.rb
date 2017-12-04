Myflix::Application.configure do
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener # letter_opener won't work in cloud9 setting
  host = 'rails-tutorial-floalex.c9.io'     # Cloud IDE 
  # host = 'localhost:3000'                     # Local server
  config.action_mailer.default_url_options = { host: host, protocol: 'https' }
  
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false
end
