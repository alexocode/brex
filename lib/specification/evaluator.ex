defmodule Specification.Evaluator do
  @moduledoc """
  Evaluates a value based on the given rules. Returns mapping of rules to their
  result. This mapping can then be processed by any module conforming to the
  `Specification.ResultFormatter` behaviour.

  ## Examples
  ### Simple

      iex> Specification.Evaluator.evaluate(&is_map/1, %{})
      {&:erlang.is_map/1, true}

      iex> Specification.Evaluator.evaluate(&is_map/1, [])
      {&:erlang.is_map/1, false}

      iex> Specification.Evaluator.evaluate([&is_map/1, &Enum.empty?/1], [])
      [{&:erlang.is_map/1, false}, {&Enum.empty?/1, true}]

  ### Operators
  #### any

      iex> has_keys = Specification.Operator.any([&is_map/1, &Keyword.keyword?/1])
      iex> Specification.Evaluator.evaluate(has_keys, %{})
      {{:any, [{&:erlang.is_map/1, true}, {&Keyword.keyword?/1, false}]}, true}
      iex> Specification.Evaluator.evaluate(has_keys, [])
      {{:any, [{&:erlang.is_map/1, false}, {&Keyword.keyword?/1, true}]}, true}
      iex> Specification.Evaluator.evaluate(has_keys, [1])
      {{:any, [{&:erlang.is_map/1, false}, {&Keyword.keyword?/1, false}]}, false}

  #### all

      iex> is_empty_list = Specification.Operator.all([&is_list/1, &Enum.empty?/1])
      iex> Specification.Evaluator.evaluate(is_empty_list, [])
      {{:all, [{&:erlang.is_list/1, true}, {&Enum.empty?/1, true}]}, true}
      iex> Specification.Evaluator.evaluate(is_empty_list, [1])
      {{:all, [{&:erlang.is_list/1, true}, {&Enum.empty?/1, false}]}, false}

  #### negate

      iex> is_non_empty_list = [&is_list/1, Specification.Operator.negate(&Enum.empty?/1)]
      iex> Specification.Evaluator.evaluate(is_non_empty_list, [])
      [{&:erlang.is_list/1, true}, {{:negate, [{&Enum.empty?/1, true}]}, false}]
      iex> Specification.Evaluator.evaluate(is_non_empty_list, [1])
      [{&:erlang.is_list/1, true}, {{:negate, [{&Enum.empty?/1, false}]}, true}]
  """

  import Specification, only: [passed_evaluation?: 1]

  alias Specification.Types

  @spec evaluate(Types.rules() | Types.rule(), Types.value()) :: Types.results()
  def evaluate(rules, value) when is_list(rules) do
    Enum.map(rules, &evaluate(&1, value))
  end

  def evaluate(rule, value) when is_atom(rule) do
    {rule, Specification.Rule.call_evaluate(rule, value)}
  end

  def evaluate(rule, value) when is_function(rule, 1) do
    result =
      try do
        rule.(value)
      catch
        error -> {:error, error}
      rescue
        error -> {:error, error}
      end

    {rule, result}
  end

  for operator <- [:all, :any, :negate] do
    def evaluate({unquote(operator), rules}, value) do
      evaluated_rules = evaluate(rules, value)
      operator_result = {unquote(operator), evaluated_rules}
      aggregated_result = aggregate_result(operator_result)

      {operator_result, aggregated_result}
    end
  end

  def evaluate(rule, _value) do
    raise ArgumentError, "Don't know how to evaluate rule `#{inspect(rule)}`!"
  end

  defp aggregate_result({:all, results}), do: Enum.all?(results, &passed_evaluation?/1)
  defp aggregate_result({:any, results}), do: Enum.any?(results, &passed_evaluation?/1)
  defp aggregate_result({:negate, results}), do: not Enum.all?(results, &passed_evaluation?/1)
end
