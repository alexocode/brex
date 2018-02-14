defmodule Support.Rules.Operator.BothOptions do
  use Spex.Operator,
    aggregator: &Enum.all?/1,
    rules: :rules

  defstruct [:rules]
end
