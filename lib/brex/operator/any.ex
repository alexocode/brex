defmodule Brex.Operator.Any do
  @moduledoc false
  use Brex.Operator, aggregator: &Enum.any?/1

  defstruct [:clauses]
end
