# stacklab/licensing_service.rb
# Versão modificada para fins de desenvolvimento local, contornando a verificação de licença.

module Stacklab
  module LicensingService
    # Retorna uma resposta de licença "Enterprise" falsa, ativando todas as funcionalidades.
    # A verificação de token e a chamada à API foram removidas.
    def self.get_license_info(force_refresh: false)
      {
        token_provided: true,
        plan: 'stacklab pro', # Simula um plano de alto nível.
        features: {
          kanban_pro: true,
          stacklab_modules: true,
          cloud_configs: true
        }.with_indifferent_access,
        message: 'Licença Enterprise ativada localmente para fins de desenvolvimento.',
        raw_response: { status: 'Bypass bem-sucedido' }
      }.with_indifferent_access
    end

    # Força a resposta para "true", garantindo que qualquer verificação de funcionalidade passe.
    def self.feature_enabled?(feature_key)
      # A lógica original foi removida para sempre retornar true.
      true
    end

    # Retorna o plano simulado.
    def self.current_plan
      get_license_info[:plan]
    end

    # Retorna a mensagem da licença simulada.
    def self.license_message
      get_license_info[:message]
    end

    # Retorna "true" para simular que um token está configurado.
    def self.token_configured_in_env?
      true
    end

    # Função de cache não é mais necessária, mas mantida para não quebrar chamadas.
    def self.clear_cache!
      # Nenhuma ação necessária, pois não há cache.
      # Rails.logger.info 'Cache de licença não está em uso (modo bypass).'
    end

    # Função de resposta padrão não é mais usada no fluxo principal.
    def self.default_ce_response(message, raw_api_response = nil, token_was_provided: false)
      # Este método não será chamado, mas é mantido por segurança.
      get_license_info
    end
  end
end