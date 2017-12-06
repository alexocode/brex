defmodule Specification do
  @moduledoc """
  Documentation for Specification
  """

  alias Specification.ResultFormatter, as: Formatter

  defdelegate evaluate(rules, value), to: Specification.Evaluator

  defdelegate passed_evaluation?(results), to: Formatter.Boolean, as: :format

  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed_evaluation?()
  end
end
