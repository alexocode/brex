defmodule Support.Rules.Operator.NoOptionAndBothDefintions do
  use Spex.Operator

  defstruct [:rules]

  def aggregator(_), do: &Enum.all?/1

  def nested_rules(%{rules: rules}), do: rules
end
