defmodule Spex.Result.Formatter.Rules do
  @moduledoc """
  A result formatter which reduces the given results to the contained rules.
  """

  use Spex.Result.Formatter

  alias Spex.Operator

  @impl true
  def format(results) do
    Enum.map(results, &extract_rule/1)
  end

  defp extract_rule(%Result{rule: rule}), do: safe_extract_rule(rule)
  defp extract_rule(other), do: invalid_result!(other)

  defp safe_extract_rule(rule) do
    if Operator.operator?(rule) do
      operator = Operator.link!(rule)

      clauses =
        rule
        |> Operator.clauses!()
        |> format()

      {operator, clauses}
    else
      rule
    end
  end
end
