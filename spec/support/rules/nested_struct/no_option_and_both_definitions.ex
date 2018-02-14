defmodule Support.Rules.Operator.NoOptionAndBothDefintions do
  use Spex.Operator

  defstruct [:clauses]

  def aggregator(_), do: &Enum.all?/1

  def clauses(%{clauses: clauses}), do: clauses
end
