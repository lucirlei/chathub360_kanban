# config/initializers/stacklab_initializer.rb

# Carrega o ChatwootApp e, por consequência, o Stacklab::LicensingService durante a inicialização.
require Rails.root.join('lib', 'chatwoot_app')

Rails.application.config.after_initialize do
  ChatwootApp.send(:ensure_stacklab_service_loaded) if ChatwootApp.respond_to?(:ensure_stacklab_service_loaded, true)
end
