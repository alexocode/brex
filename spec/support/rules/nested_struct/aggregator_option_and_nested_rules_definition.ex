defmodule Support.Rules.Operator.AggregatorOptionAndNestedRulesDefintion do
  use Spex.Rule.Operator, aggregator: &Enum.all?/1

  defstruct [:rules]

  def nested_rules(%{rules: rules}), do: rules
end
