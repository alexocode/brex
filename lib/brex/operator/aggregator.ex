defmodule Brex.Operator.Aggregator do
  @moduledoc false

  defdelegate all?(enum), to: Enum
  defdelegate any?(enum), to: Enum

  def none?(enum), do: not all?(enum)
end
