defmodule Support.Rules.NestedStruct.NoOptionAndBothDefintions do
  use Spex.Rule.NestedStruct

  defstruct [:nested]

  def aggregator(_), do: &Enum.all?/1

  def nested_rules(%{nested: nested}), do: nested
end
