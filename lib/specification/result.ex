defmodule Specification.Result do
  @moduledoc """
  Represents a result of a rule evaluation.

  It contains the rules and the result which was returned by the rules.
  """
  alias Specification.Types

  @type result_value :: boolean() | :ok | {:ok, any()} | {:error, any()}

  @type t :: %__MODULE__{
          rule: Types.rule() | Types.rules(),
          result: result_value(),
          value: Types.t()
        }
  defstruct [:rule, :result, :value]

  def passed?(%__MODULE__{result: result}), do: passed?(result)

  def passed?(boolean) when is_boolean(boolean), do: boolean

  def passed?(:ok), do: true
  def passed?({:ok, _}), do: true

  def passed?(:error), do: false
  def passed?({:error, _}), do: false
end
