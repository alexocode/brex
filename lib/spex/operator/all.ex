defmodule Spex.Operator.All do
  @moduledoc false
  use Spex.Operator, aggregator: &Enum.all?/1

  defstruct [:clauses]
end
