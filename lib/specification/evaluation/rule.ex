defmodule Specification.Evaluation.Rule do
  @moduledoc false

  import Specification, only: [passed_evaluation?: 1]

  def evaluate(rules, value) when is_list(rules) do
    Enum.map(rules, &evaluate(&1, value))
  end

  def evaluate(rule, value) when is_atom(rule) do
    {rule, Specification.Rule.evaluate(rule, value)}
  end

  def evaluate(rule, value) when is_function(rule, 1) do
    {rule, rule.(value)}
  end

  for operator <- [:all, :any, :negate] do
    def evaluate({unquote(operator), rules}, value) do
      evaluated_rules = evaluate(rules, value)
      operator_result = {unquote(operator), evaluated_rules}
      aggregated_result = aggregate_result(operator_result)

      {operator_result, aggregated_result}
    end
  end

  def evaluate(rule, _value) do
    raise ArgumentError, "Don't know how to evaluate rule `#{inspect(rule)}`!"
  end

  defp aggregate_result({:all, results}), do: Enum.all?(results, &passed_evaluation?/1)
  defp aggregate_result({:any, results}), do: Enum.any?(results, &passed_evaluation?/1)
  defp aggregate_result({:negate, results}), do: not Enum.all?(results, &passed_evaluation?/1)
end
