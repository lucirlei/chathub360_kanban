class KanbanItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @account_user.administrator? || @account_user.agent?
  end

  def create?
    @account_user.administrator? || @account_user.agent?
  end

  def update?
    @account_user.administrator? || @account_user.agent?
  end

  def destroy?
    @account_user.administrator?
  end

  # Métodos auxiliares
  def assigned_to_user?
    record.assigned_agents.any? { |a| a['id'] == @account_user.id }
  end

  def move_to_stage?
    update?
  end

  def reorder?
    update?
  end

  def move?
    update?
  end

  def create_checklist_item?
    update?
  end

  def create_note?
    update?
  end

  def assign_agent?
    update?
  end

  def change_status?
    update?
  end

  def assign_agent_to_checklist_item?
    update?
  end

  def remove_agent_from_checklist_item?
    update?
  end

  def remove_agent?
    update?
  end

  class Scope < Scope
    def resolve
      if @account_user.administrator?
        scope.where(account_id: Current.account.id)
      else
        # Agents veem apenas itens em que estão assigned
        scope.where(account_id: Current.account.id).select do |item|
          item.assigned_agents.any? { |a| a['id'] == @account_user.id }
        end
      end
    end
  end
end
