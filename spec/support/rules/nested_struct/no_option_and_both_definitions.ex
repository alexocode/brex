defmodule Support.Rules.Operator.NoOptionAndBothDefintions do
  use Spex.Operator

  defstruct [:rules]

  def aggregator(_), do: &Enum.all?/1

  def clauses(%{rules: rules}), do: rules
end
