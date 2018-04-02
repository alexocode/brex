defmodule Spex.Operator.Any do
  @moduledoc false
  use Spex.Operator, aggregator: &Enum.any?/1

  defstruct [:clauses]
end
