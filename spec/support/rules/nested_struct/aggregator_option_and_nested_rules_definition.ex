defmodule Support.Rules.Operator.AggregatorOptionAndNestedRulesDefintion do
  use Spex.Operator, aggregator: &Enum.all?/1

  defstruct [:rules]

  def clauses(%{rules: rules}), do: rules
end
