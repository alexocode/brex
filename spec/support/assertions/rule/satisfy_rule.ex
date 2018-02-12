defmodule Spex.Assertions.Rule.SatisfyRule do
  @moduledoc false
  use ESpec.Assertions.Interface

  defp match(value, {rule, nil}) do
    match(value, {rule, Spex.Rule})
  end

  defp match(value, {rule, type}) do
    result = type.evaluate(rule, value)

    {Spex.Result.passed?(result), result}
  end

  defp success_message(value, {rule, type}, _, positive) do
    does = if positive, do: "does", else: "does not"
    "`#{inspect(value)}` #{does} satisfy #{rule_of_type(type)}: #{inspect(rule)}."
  end

  defp error_message(value, {rule, type}, result, positive) do
    to = if positive, do: "to", else: "not to"
    does_not = if positive, do: "does not", else: "does"

    """
    Expected `#{inspect(value)}` #{to} satisfy #{rule_of_type(type)}, but it #{does_not}!
    iex> rule = #{inspect(rule)}
    iex> value = #{inspect(value)}
    iex> #{inspect(type)}.evaluate(rule, value)
    #{inspect(result)}\
    """
  end

  defp rule_of_type(nil), do: "rule"
  defp rule_of_type(type), do: "rule of type `#{inspect(type)}`"
end
