defmodule Specification do
  @moduledoc """
  Documentation for Specification
  """

  defdelegate evaluate(rules, value), to: Specification.Evaluation.Rule
  defdelegate passed_evaluation?(results), to: Specification.Evaluation.Result, as: :evaluate

  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed_evaluation?()
  end
end
