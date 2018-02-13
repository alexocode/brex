defmodule Support.Rules.NestedStruct.AggregatorOptionAndNestedRulesDefintion do
  use Spex.Rule.NestedStruct, aggregator: &Enum.all?/1

  defstruct [:nested]

  def nested_rules(%{nested: nested}), do: nested
end
