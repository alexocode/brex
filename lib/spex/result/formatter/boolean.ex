defmodule Spex.Result.Formatter.Boolean do
  @moduledoc """
  A result formatter which reduces the given results to a single boolean
  specifying whether the rules have been fulfilled or not.
  """

  use Spex.Result.Formatter

  @impl true
  def format(results) do
    Enum.all?(results, &Result.passed?/1)
  end
end
