defmodule Spex.Result.Formatter.Rules do
  @moduledoc """
  A result formatter which reduces the given results to the contained rules.

  # Examples

      iex> results = [
      ...>   %Spex.Result{rule: &is_list/1, evaluation: true, value: [42]},
      ...>   %Spex.Result{rule: &is_atom/1, evaluation: false, value: [42]},
      ...>   %Spex.Result{rule: &is_binary/1, evaluation: false, value: [42]},
      ...>   %Spex.Result{rule: &is_map/1, evaluation: false, value: [42]}
      ...> ]
      iex> Spex.Result.Formatter.Rules.format(results)
      [&is_list/1, &is_atom/1, &is_binary/1, &is_map/1]

      iex> results = [
      ...>   %Spex.Result{rule: &is_list/1, evaluation: true, value: [42]},
      ...>   %Spex.Result{
      ...>     rule: %Spex.Operator.None{clauses: [&Keyword.keyword?/1]},
      ...>     evaluation: {:ok, [
      ...>       %Spex.Result{
      ...>         rule: &Keyword.keyword?/1,
      ...>         evaluation: false,
      ...>         value: [42]
      ...>       }
      ...>     ]},
      ...>     value: [42]
      ...>   },
      ...> ]
      iex> Spex.Result.Formatter.Rules.format(results)
      [&is_list/1, %Spex.Operator.None{clauses: [&Keyword.keyword?/1]}]
  """

  use Spex.Result.Formatter

  @impl true
  def format(results) do
    Enum.map(results, &extract_rule/1)
  end

  defp extract_rule(%Result{rule: rule}), do: rule
  defp extract_rule(other), do: invalid_result!(other)
end
