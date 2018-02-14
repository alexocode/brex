defmodule Spex.Operator.All do
  use Spex.Rule.Operator, aggregator: &Enum.all?/1

  defstruct [:rules]
end
