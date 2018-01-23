defmodule Specification.Rule.Operator do
  use Specification.Rule

  import Specification.Result, only: [passed?: 1]

  alias Specification.{Operator, Result}

  @impl Specification.Rule
  def is_rule?(rule) do
    Operator.operator?(rule)
  end

  @impl Specification.Rule
  def evaluate(operator, value) do
    evaluate(operator, value, with: &Specification.evaluate(&1, value))
  end

  defp evaluate(operator, value, with: transform) do
    evaluated = transform_clauses(operator, transform)

    operator
    |> Operator.link!()
    |> aggregate_operator_results(evaluated)
    |> if do
      {:ok, evaluated}
    else
      {:error, evaluated}
    end
  end

  defp transform_clauses(operator, transform) do
    operator
    |> Operator.clauses!()
    |> Enum.map(transform)
  end

  defp aggregate_operator_results(:all, results) do
    Enum.all?(results, &passed?/1)
  end

  defp aggregate_operator_results(:any, results) do
    Enum.any?(results, &passed?/1)
  end

  defp aggregate_operator_results(:none, results) do
    not Enum.any?(results, &passed?/1)
  end

  @impl Specification.Rule
  def result(operator, value) do
    %Result{
      rule: operator,
      result: evaluate(operator, value, with: &Specification.result(&1, value)),
      value: value
    }
  end
end
