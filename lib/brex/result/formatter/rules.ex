defmodule Brex.Result.Formatter.Rules do
  @moduledoc """
  A result formatter which reduces the given results to the contained rules.

  # Examples

      iex> results = [
      ...>   %Brex.Result{rule: &is_list/1, evaluation: true, value: [42]},
      ...>   %Brex.Result{rule: &is_atom/1, evaluation: false, value: [42]},
      ...>   %Brex.Result{rule: &is_binary/1, evaluation: false, value: [42]},
      ...>   %Brex.Result{rule: &is_map/1, evaluation: false, value: [42]}
      ...> ]
      iex> Brex.Result.Formatter.Rules.format(results)
      [&is_list/1, &is_atom/1, &is_binary/1, &is_map/1]

      iex> results = [
      ...>   %Brex.Result{rule: &is_list/1, evaluation: true, value: [42]},
      ...>   %Brex.Result{
      ...>     rule: Brex.none([&Keyword.keyword?/1]),
      ...>     evaluation: {:ok, [
      ...>       %Brex.Result{
      ...>         rule: &Keyword.keyword?/1,
      ...>         evaluation: false,
      ...>         value: [42]
      ...>       }
      ...>     ]},
      ...>     value: [42]
      ...>   },
      ...> ]
      iex> Brex.Result.Formatter.Rules.format(results)
      [&is_list/1, %Brex.Operator{aggregator: &Brex.Operator.Aggregator.none?/1, clauses: [&Keyword.keyword?/1]}]


      iex> Brex.Result.Formatter.Rules.format([:foo])
      ** (ArgumentError) Invalid result! Expected a list of or single `Brex.Result` struct but received: [:foo]
          (brex) lib/brex/result/formatter.ex:45: Brex.Result.Formatter.invalid_result!/1
          (elixir) lib/enum.ex:1294: Enum."-map/2-lists^map/1-0-"/2

  """

  use Brex.Result.Formatter

  @impl true
  def format(%Result{rule: rule}), do: rule
end
