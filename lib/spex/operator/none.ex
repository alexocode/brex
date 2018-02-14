defmodule Spex.Operator.None do
  use Spex.Rule.Operator, aggregator: &(not Enum.any?(&1))

  defstruct [:rules]
end
