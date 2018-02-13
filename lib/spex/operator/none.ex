defmodule Spex.Operator.None do
  use Spex.Operator, aggregator: &(not Enum.any?(&1))

  defstruct [:clauses]
end
