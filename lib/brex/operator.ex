defmodule Brex.Operator do
  @moduledoc """
  A struct which represents a rule linking two or more other rules together. It
  does this by accepting a list of `clauses` and an `aggregator`, being an arity
  1 function which reduces a list of booleans into a single boolean.

  # Custom Operators

  Creating a custom operator is merely a case of wrapping your rules into the
  `Brex.Operator` struct and providing your custom `aggregator` alongside.

  ## Examples

      %Brex.Operator{
        rules: [my_rule1, my_rule2],
        aggregator: my_aggregation_function # For example &Enum.all?/1
      }

  """
  use Brex.Rule.Struct

  @type aggregator :: (list(boolean()) -> boolean())
  @type clauses :: list(Brex.Types.rule())
  @type t :: %__MODULE__{
          aggregator: aggregator(),
          clauses: clauses()
        }
  defstruct [:aggregator, :clauses]

  def evaluate(%__MODULE__{} = rule, value) do
    results = evaluate_clauses(rule, value)

    if aggregate(rule, results) do
      {:ok, results}
    else
      {:error, results}
    end
  end

  defp evaluate_clauses(%{clauses: clauses}, value) do
    Enum.map(clauses, &Brex.evaluate(&1, value))
  end

  defp aggregate(%{aggregator: aggregator}, results) do
    results
    |> Enum.map(&Brex.passed?/1)
    |> aggregator.()
  end

  def clauses(%__MODULE__{clauses: clauses}), do: {:ok, clauses}
  def clauses(_), do: :error
end
