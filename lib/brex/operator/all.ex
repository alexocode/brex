defmodule Brex.Operator.All do
  @moduledoc false
  use Brex.Operator, aggregator: &Enum.all?/1

  defstruct [:clauses]
end
