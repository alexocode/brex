defmodule Support.Rules.Operator.RulesOptionAndAggregatorDefintion do
  use Spex.Rule.Operator, rules: :rules

  defstruct [:rules]

  def aggregator(_), do: &Enum.all?/1
end
