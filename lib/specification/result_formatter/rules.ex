defmodule Specification.ResultFormatter.Rules do
  @moduledoc """
  A result formatter which reduces the given results to the contained rules.
  """

  use Specification.ResultFormatter

  alias Specification.Operator

  @impl true
  def format(rules_and_results) do
    Enum.map(rules_and_results, &extract_rule/1)
  end

  defp extract_rule({rule, result}) when is_boolean(result), do: safe_extract_rule(rule)
  defp extract_rule(other), do: invalid_result!(other)

  defp safe_extract_rule(rule) do
    if Operator.operator?(rule) do
      operator = Operator.rule!(rule)

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
