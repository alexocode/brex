defmodule Support.Operators.ClausesOptionAndAggregatorDefintion do
  use Brex.Operator, clauses: :clauses

  defstruct [:clauses]

  def aggregator(_), do: &Enum.all?/1
end
