defmodule Specification do
  @moduledoc """
  Documentation for Specification
  """

  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed_evaluation?()
  end

  def evaluate(rules, value) do
    rules
    |> List.wrap()
    |> Enum.map(&do_evaluate(&1, value))
  end

  defp do_evaluate(rule, value) when is_function(rule, 1) do
    rule.(value)
  end

  for operator <- [:all, :any, :negate] do
    defp do_evaluate({unquote(operator), rules}, value) do
      {unquote(operator), evaluate(rules, value)}
    end
  end

  defp do_evaluate(rule, value) do
    raise ArgumentError, "Don't know how to evaluate rule `#{inspect(rule)}`!"
  end

  defp passed_evaluation?(results) when is_list(results) do
    Enum.all?(results, &passed_evaluation?/1)
  end

  defp passed_evaluation?(boolean) when is_boolean(boolean), do: boolean
  defp passed_evaluation?(:ok), do: true
  defp passed_evaluation?({:ok, _}), do: true
  defp passed_evaluation?({:error, _}), do: false

  defp passed_evaluation?(result) when is_tuple(result) do
    case result do
      {:all, results} ->
        Enum.all?(results, &passed_evaluation?/1)

      {:any, results} ->
        Enum.any?(results, &passed_evaluation?/1)

      {:negate, results} ->
        not Enum.all?(results, &passed_evaluation?/1)
    end
  end
end
