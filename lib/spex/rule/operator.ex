# defmodule Spex.Rule.Operator do
#   @moduledoc """
#   This rule type contains the evaluation logic for operators which are specified
#   in `Spex.Operator`.

#   It takes these operators and performs the necessary logic to aggregate the
#   results of all operator clauses.

#   Supported operators are:
#   - `all`
#   - `any`
#   - `none`
#   """
#   use Spex.Rule

#   import Spex.Result, only: [passed?: 1]

#   alias Spex.{Operator, Result}

#   @type t :: Spex.Operator.t()

#   @impl Spex.Rule
#   def is_rule_of_type?(rule) do
#     Operator.operator?(rule)
#   end

#   @impl Spex.Rule
#   def evaluate(operator, value) do
#     transform(operator, with: &Spex.evaluate(&1, value))
#   end

#   defp transform(operator, with: transform) do
#     evaluated = transform_clauses(operator, transform)

#     operator
#     |> Operator.link!()
#     |> aggregate_operator_results(evaluated)
#     |> if do
#       {:ok, evaluated}
#     else
#       {:error, evaluated}
#     end
#   end

#   defp transform_clauses(operator, transform) do
#     operator
#     |> Operator.clauses!()
#     |> Enum.map(transform)
#   end

#   defp aggregate_operator_results(:all, results) do
#     Enum.all?(results, &passed?/1)
#   end

#   defp aggregate_operator_results(:any, results) do
#     Enum.any?(results, &passed?/1)
#   end

#   defp aggregate_operator_results(:none, results) do
#     not Enum.any?(results, &passed?/1)
#   end

#   @impl Spex.Rule
#   def result(operator, value) do
#     %Result{
#       rule: operator,
#       evaluation: transform(operator, with: &Spex.result(&1, value)),
#       value: value
#     }
#   end
# end
