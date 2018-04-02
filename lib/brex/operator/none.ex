defmodule Brex.Operator.None do
  @moduledoc false
  use Brex.Operator, aggregator: &(not Enum.any?(&1))

  defstruct [:clauses]
end
