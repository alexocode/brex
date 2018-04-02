defmodule Support.Operators.NoOptionAndBothDefintions do
  use Brex.Operator

  defstruct [:clauses]

  def aggregator(_), do: &Enum.all?/1

  def clauses(%{clauses: clauses}), do: clauses
end
