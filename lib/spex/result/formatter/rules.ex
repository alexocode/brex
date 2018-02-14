defmodule Spex.Result.Formatter.Rules do
  @moduledoc """
  A result formatter which reduces the given results to the contained rules.
  """

  use Spex.Result.Formatter

  @impl true
  def format(results) do
    Enum.map(results, &extract_rule/1)
  end

  defp extract_rule(%Result{rule: rule}), do: rule
  defp extract_rule(other), do: invalid_result!(other)
end
