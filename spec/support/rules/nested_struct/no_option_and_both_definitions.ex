defmodule Support.Rules.Operator.NoOptionAndBothDefintions do
  use Spex.Rule.Operator

  defstruct [:nested]

  def aggregator(_), do: &Enum.all?/1

  def nested_rules(%{nested: nested}), do: nested
end
