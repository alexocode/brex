defmodule Support.Operators.ClausesOptionAndAggregatorDefintion do
  use Spex.Operator, clauses: :clauses

  defstruct [:clauses]

  def aggregator(_), do: &Enum.all?/1
end
