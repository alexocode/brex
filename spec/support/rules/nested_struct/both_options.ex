defmodule Support.Rules.Operator.BothOptions do
  use Spex.Rule.Operator,
    aggregator: &Enum.all?/1,
    nested: :nested

  defstruct [:nested]
end
