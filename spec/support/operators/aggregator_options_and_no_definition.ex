defmodule Support.Operators.AggregatorOptionAndNoDefintion do
  use Spex.Operator, aggregator: &Enum.all?/1

  defstruct [:clauses]
end
