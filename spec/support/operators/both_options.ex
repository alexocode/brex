defmodule Support.Operators.BothOptions do
  use Brex.Operator,
    aggregator: &Enum.all?/1,
    clauses: :clauses

  defstruct [:clauses]
end
