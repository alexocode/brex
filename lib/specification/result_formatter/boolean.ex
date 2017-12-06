defmodule Specification.ResultFormatter.Boolean do
  @moduledoc """
  A result formatter which reduces the given results to a single boolean
  specifying whether the rules have been fulfilled or not.
  """

  use Specification.ResultFormatter

  @impl true
  def format(rules_and_results) do
    rules_and_results
    |> Enum.map(&extract_result/1)
    |> Enum.all?(&positive_result?/1)
  end

  defp extract_result({_rule, result}), do: result
  defp extract_result(other), do: invalid_result!(other)

  defp positive_result?(boolean) when is_boolean(boolean), do: boolean
  defp positive_result?(:ok), do: true
  defp positive_result?({:ok, _}), do: true
  defp positive_result?({:error, _}), do: false
end
