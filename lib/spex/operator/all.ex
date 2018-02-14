defmodule Spex.Operator.All do
  use Spex.Operator, aggregator: &Enum.all?/1

  defstruct [:rules]
end
