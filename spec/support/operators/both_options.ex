defmodule Support.Operators.BothOptions do
  use Spex.Operator,
    aggregator: &Enum.all?/1,
    clauses: :clauses

  defstruct [:clauses]
end
