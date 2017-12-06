defmodule Specification do
  @moduledoc """
  Documentation for Specification
  """

  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed_evaluation?()
  end

  def evaluate(rules, value) do
    rules
    |> List.wrap()
    |> Enum.map(&do_evaluate(&1, value))
  end

  defp do_evaluate(rule, value) when is_atom(rule) do
    {rule, Specification.Rule.evaluate(rule, value)}
  end

  defp do_evaluate(rule, value) when is_function(rule, 1) do
    {rule, rule.(value)}
  end

  for operator <- [:all, :any, :negate] do
    defp do_evaluate({unquote(operator), rules}, value) do
      evaluated_rules = evaluate(rules, value)
      operator_result = {unquote(operator), evaluated_rules}
      aggregated_result = aggregate_result(operator_result)

      {operator_result, aggregated_result}
    end
  end

  defp do_evaluate(rule, _value) do
    raise ArgumentError, "Don't know how to evaluate rule `#{inspect(rule)}`!"
  end

  defp aggregate_result({:all, results}), do: Enum.all?(results, &passed_evaluation?/1)
  defp aggregate_result({:any, results}), do: Enum.any?(results, &passed_evaluation?/1)
  defp aggregate_result({:negate, results}), do: not Enum.all?(results, &passed_evaluation?/1)

  def passed_evaluation?(result) do
    result
    |> List.wrap()
    |> Enum.map(&extract_result/1)
    |> Enum.all?(&positive_result?/1)
  end

  defp extract_result({_rule, result}), do: result

  defp extract_result(other) do
    raise ArgumentError,
          "Invalid evaluation result! Expects a list of two value tuples like `{MyCustomRule, true}`. " <>
            "Instead received: #{inspect(other)}"
  end

  defp positive_result?(boolean) when is_boolean(boolean), do: boolean
  defp positive_result?(:ok), do: true
  defp positive_result?({:ok, _}), do: true
  defp positive_result?({:error, _}), do: false
end
