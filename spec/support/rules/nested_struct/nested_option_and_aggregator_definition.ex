defmodule Support.Rules.NestedStruct.NestedOptionAndAggregatorDefintion do
  use Spex.Rule.NestedStruct, nested: :nested

  defstruct [:nested]

  def aggregator(_), do: &Enum.all?/1
end
