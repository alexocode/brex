defmodule Brex.Operator.Aggregator do
  @moduledoc false

  defdelegate all?(enum), to: Enum
  defdelegate any?(enum), to: Enum

  @doc """
  # Examples

    iex> Brex.Operator.Aggregator.none?([])
    true

    iex> Brex.Operator.Aggregator.none?([nil, nil])
    true

    iex> Brex.Operator.Aggregator.none?([1, 2, nil])
    true

    iex> Brex.Operator.Aggregator.none?([1, 2, 3])
    false
  """
  def none?([]), do: true
  def none?(enum), do: not all?(enum)
end
