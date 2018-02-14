defmodule Support.Rules.Operator.NestedOptionAndAggregatorDefintion do
  use Spex.Rule.Operator, nested: :nested

  defstruct [:nested]

  def aggregator(_), do: &Enum.all?/1
end
