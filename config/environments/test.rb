Myflix::Application.configure do
  config.cache_classes = true

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection    = false

  config.action_mailer.delivery_method = :test
  
  host = 'rails-tutorial-floalex.c9.io'     # Cloud IDE
  # host = 'localhost:3000'                     # Local server
  config.action_mailer.default_url_options = { host: host, port: '52662' }
  config.active_support.deprecation = :stderr
end
