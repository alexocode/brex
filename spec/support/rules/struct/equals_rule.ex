defmodule Support.Rules.EqualsRule do
  use Brex.Rule.Struct

  defstruct [:value]

  def evaluate(%__MODULE__{value: expected}, value) do
    expected == value
  end
end
