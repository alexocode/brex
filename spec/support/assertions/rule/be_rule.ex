defmodule Spex.Assertions.Rule.BeRule do
  @moduledoc false
  use ESpec.Assertions.Interface

  defp match(rule, type) do
    is_valid = is_rule?(type, rule)
    {is_valid, is_valid}
  end

  defp is_rule?(:any, rule), do: Spex.Rule.type(rule) != nil
  defp is_rule?(type, rule), do: Spex.Rule.type(rule) == type

  defp success_message(rule, type, _, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(rule)}` #{to} be #{rule_of_type(type)}."
  end

  defp error_message(rule, type, _, positive) do
    to = if positive, do: "to", else: "not to"
    it_is = if positive, do: "it's not", else: "it is"

    """
    Expected rule #{to} be #{rule_of_type(type)}, but #{it_is}!
    iex> rule = #{inspect(rule)}
    iex> Spex.Rule.type(rule)
    #{inspect(Spex.Rule.type(rule))}
    """
  end

  defp rule_of_type(nil), do: "rule"
  defp rule_of_type(type), do: "of type `#{inspect(type)}`"
end
