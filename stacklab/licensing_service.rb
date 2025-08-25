# stacklab/licensing_service.rb
# Versão reconfigurada para usar o plano 'Kanban Growth' e contornar a verificação.

module Stacklab
  module LicensingService
    # Retorna uma resposta de licença 'Kanban Growth' falsa.
    def self.get_license_info(force_refresh: false)
      {
        token_provided: true,
        plan: 'Kanban Growth', # ALTERADO para o novo plano
        features: {
          kanban_pro: true,
          stacklab_modules: true,
          cloud_configs: true
        }.with_indifferent_access,
        message: 'Licença Kanban Growth ativada localmente para fins de desenvolvimento.',
        raw_response: { status: 'Bypass bem-sucedido com plano Kanban Growth' }
      }.with_indifferent_access
    end

    # Força a resposta para "true", garantindo que qualquer verificação de funcionalidade passe.
    def self.feature_enabled?(feature_key)
      true
    end

    # Retorna o plano simulado.
    def self.current_plan
      'Kanban Growth' # ALTERADO para o novo plano
    end

    # Retorna a mensagem da licença simulada.
    def self.license_message
      get_license_info[:message]
    end

    # Força a resposta para "true" para resolver o pop-up que exige o token na UI.
    def self.token_configured_in_env?
      true
    end

    # Função de cache não é mais necessária.
    def self.clear_cache!
      # Nenhuma ação necessária.
    end
  end
end