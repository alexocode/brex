defmodule Specification.Assertions.Rule.BeRule do
  @moduledoc false
  use ESpec.Assertions.Interface

  defp match(rule, nil) do
    match(rule, Specification.Rule)
  end

  defp match(rule, type) do
    is_valid = type.is_rule?(rule)
    {is_valid, is_valid}
  end

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
    iex> Specification.Rule.type(rule)
    #{inspect(Specification.Rule.type(rule))}
    """
  end

  defp rule_of_type(nil), do: "rule"
  defp rule_of_type(type), do: "of type `#{inspect(type)}`"
end
