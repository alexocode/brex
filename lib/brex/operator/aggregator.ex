defmodule Brex.Operator.Aggregator do
  @moduledoc false

  defdelegate all?(enum), to: Enum
  defdelegate any?(enum), to: Enum

  @doc """
  ## Examples

    iex> Brex.Operator.Aggregator.none?([])
    true

    iex> Brex.Operator.Aggregator.none?([false, false])
    true

    iex> Brex.Operator.Aggregator.none?([true, true, false])
    false

    iex> Brex.Operator.Aggregator.none?([true, true, true])
    false

  """
  def none?([]), do: true
  def none?(enum), do: not any?(enum)
end
