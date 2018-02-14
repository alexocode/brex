defmodule Support.Rules.Operator.RulesOptionAndAggregatorDefintion do
  use Spex.Operator, rules: :rules

  defstruct [:rules]

  def aggregator(_), do: &Enum.all?/1
end
