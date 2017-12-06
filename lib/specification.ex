defmodule Specification do
  @moduledoc """
  The main module. Provides shortcut functions to evaluate rules, reduce the
  results to a boolean and to check if some value satisfy some rules.

  For further information take a look at `Specification.Evaluator` and `Specification.ResultFormatter`.
  """

  alias Specification.ResultFormatter, as: Formatter
  alias Specification.Types

  defdelegate evaluate(rules, value), to: Specification.Evaluator

  defdelegate passed_evaluation?(results), to: Formatter.Boolean, as: :format

  @spec satisfies?(Types.rules() | Types.rule(), Types.value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed_evaluation?()
  end
end
