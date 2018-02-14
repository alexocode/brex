defmodule Spex.Operator.Any do
  use Spex.Operator, aggregator: &Enum.any?/1

  defstruct [:clauses]
end
