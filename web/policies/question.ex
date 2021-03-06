defmodule AfterGlow.Question.Policy do
  import Ecto.Query
  import AfterGlow.Policy.Helpers
  def can?(nil, _action, _question), do: false
  def can?(user, :index, _question), do: has_permission(user, "Question.show")
  def can?(user, :show, _question), do: has_permission(user, "Question.show")
  def can?(user, :search, _question), do: has_permission(user, "Question.show")
  def can?(user, :results, _question), do: has_permission(user, "Question.show")
  def can?(user, :update, _question), do: has_permission(user, "Question.edit")
  def can?(user, :delete, _question), do: has_permission(user, "Question.delete")
  def can?(user, :create, _question), do: has_permission(user, "Question.create")
  def can?(_, _, _), do: false

  def scope(user, _action, scope) do
    if has_permission(user, "Settings.all") do
      scope
    else
      from(
        s in scope,
        left_join: d in assoc(s, :dashboards),
        where:
          s.owner_id == ^user.id or fragment("? = ANY (?)", ^user.email, s.shared_to) or
            fragment("? = ANY (?)", ^user.email, d.shared_to) or
            fragment("? = ANY (?)", "all", s.shared_to) or
            fragment("? = ANY (?)", "all", d.shared_to),
        group_by: s.id
      )
    end
  end
end
