defmodule Support.Rules.Operator.AggregatorOptionAndNestedRulesDefintion do
  use Spex.Rule.Operator, aggregator: &Enum.all?/1

  defstruct [:nested]

  def nested_rules(%{nested: nested}), do: nested
end
