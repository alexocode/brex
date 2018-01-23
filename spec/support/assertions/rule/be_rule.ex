defmodule Specification.Assertions.Rule.BeRule do
  @moduledoc false
  use ESpec.Assertions.Interface

  defp match(subject, nil) do
    is_valid = Specification.Rule.is_rule?(subject)
    {is_valid, is_valid}
  end

  defp match(subject, rule) do
    is_valid = rule.is_rule?(subject)
    {is_valid, is_valid}
  end

  defp success_message(subject, rule, _, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(subject)}` #{to} be rule#{format_rule(rule)}."
  end

  defp error_message(subject, rule, _, positive) do
    to = if positive, do: "to", else: "not to"
    result = if positive, do: "it's not", else: "it is"

    "Expected `#{inspect(subject)}` #{to} be rule#{format_rule(rule)}, but #{result}!"
  end

  defp format_rule(nil), do: ""
  defp format_rule(rule), do: " `#{inspect(rule)}`"
end
