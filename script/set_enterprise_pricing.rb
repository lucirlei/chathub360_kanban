# Script para desbloquear o Chatwoot como enterprise
# Execute com: rails runner script/unlock_enterprise.rb

require 'fileutils'

# Atualiza ou cria as configurações necessárias
plan = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
plan.value = 'enterprise'
plan.save!

quantity = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')
quantity.value = 9_999_999
quantity.save!

# Remove o alerta premium do Redis, se existir
if defined?(Redis::Alfred)
  Redis::Alfred.delete(Redis::Alfred::CHATWOOT_INSTALLATION_CONFIG_RESET_WARNING)
  puts 'Flag de alerta premium removida do Redis.'
else
  puts 'Redis::Alfred não está definido. Verifique se o Redis está configurado corretamente.'
end

puts 'Desbloqueio realizado: Chatwoot agora está como enterprise com 9999999 usuários.'

# --- Atualiza fallback em lib/chatwoot_hub.rb ---

hub_file = File.expand_path('../lib/chatwoot_hub.rb', __dir__)
hub_content = File.read(hub_file)

# Atualiza o fallback do pricing_plan
default_plan_regex = /(InstallationConfig\.find_by\(name: 'INSTALLATION_PRICING_PLAN'\)&\.value \|\| )['"]community['"]/
hub_content.gsub!(default_plan_regex, "\\1'enterprise'")

# Atualiza o fallback do pricing_plan_quantity
default_quantity_regex = /(InstallationConfig\.find_by\(name: 'INSTALLATION_PRICING_PLAN_QUANTITY'\)&\.value \|\| )0/
hub_content.gsub!(default_quantity_regex, '\\19999999')

File.write(hub_file, hub_content)
puts 'Fallbacks de pricing_plan e pricing_plan_quantity atualizados em lib/chatwoot_hub.rb.'
