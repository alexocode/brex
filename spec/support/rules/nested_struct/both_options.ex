defmodule Support.Rules.NestedStruct.BothOptions do
  use Spex.Rule.NestedStruct,
    aggregator: &Enum.all?/1,
    nested: :nested

  defstruct [:nested]
end
