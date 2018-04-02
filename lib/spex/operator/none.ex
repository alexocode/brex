defmodule Spex.Operator.None do
  @moduledoc false
  use Spex.Operator, aggregator: &(not Enum.any?(&1))

  defstruct [:clauses]
end
