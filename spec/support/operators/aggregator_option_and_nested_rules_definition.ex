defmodule Support.Operators.AggregatorOptionAndClausesDefintion do
  use Brex.Operator, aggregator: &Enum.all?/1

  defstruct [:clauses]

  def clauses(%{clauses: clauses}), do: clauses
end
