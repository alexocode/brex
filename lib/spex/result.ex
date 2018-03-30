defmodule Spex.Result do
  @moduledoc """
  Represents a result of a rule evaluation.

  It contains the rule and the evaluated result which was returned by the rule.
  """
  alias Spex.Types

  @type evaluation :: boolean() | :ok | {:ok, any()} | {:error, any()}
  @type rule :: Types.rule()
  @type value :: Types.value()

  @type t :: %__MODULE__{
          evaluation: evaluation(),
          rule: rule(),
          value: value()
        }
  defstruct [:evaluation, :rule, :value]

  def passed?(%__MODULE__{evaluation: result}), do: passed?(result)

  def passed?(boolean) when is_boolean(boolean), do: boolean

  def passed?(:ok), do: true
  def passed?({:ok, _}), do: true

  def passed?(:error), do: false
  def passed?({:error, _}), do: false
end
