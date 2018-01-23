defmodule Specification.Result do
  @moduledoc """
  Represents a result of a rule evaluation.

  It contains the rule and the evaluated result which was returned by the rule.
  """
  alias Specification.Types

  @type result_value :: boolean() | :ok | {:ok, any()} | {:error, any()}

  @type t :: %__MODULE__{
          rule: Types.rule() | Types.rules(),
          evaluation: result_value(),
          value: Types.t()
        }
  defstruct [:rule, :evaluation, :value]

  def passed?(%__MODULE__{evaluation: result}), do: passed?(result)

  def passed?(boolean) when is_boolean(boolean), do: boolean

  def passed?(:ok), do: true
  def passed?({:ok, _}), do: true

  def passed?(:error), do: false
  def passed?({:error, _}), do: false
end
