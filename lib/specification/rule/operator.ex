defmodule Specification.Rule.Operator do
  use Specification.Rule

  import Specification.Result, only: [passed?: 1]

  alias Specification.Operator

  @impl Specification.Rule
  def is_rule?(rule) do
    Operator.operator?(rule)
  end

  @impl Specification.Rule
  def evaluate(operator, value) do
    evaluated_clauses =
      operator
      |> Operator.clauses!()
      |> Enum.map(&Specification.evaluate(&1, value))

    operator
    |> Operator.link!()
    |> aggregate_operator_results(evaluated_clauses)
    |> if do
      {:ok, evaluated_clauses}
    else
      {:error, evaluated_clauses}
    end
  end

  defp aggregate_operator_results(:all, results) do
    Enum.all?(results, &passed?/1)
  end

  defp aggregate_operator_results(:any, results) do
    Enum.any?(results, &passed?/1)
  end

  defp aggregate_operator_results(:none, results) do
    not Enum.all?(results, &passed?/1)
  end
end
