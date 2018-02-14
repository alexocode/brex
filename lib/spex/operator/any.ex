defmodule Spex.Operator.Any do
  use Spex.Rule.Operator, aggregator: &Enum.any?/1

  defstruct [:rules]
end
