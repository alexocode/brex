defmodule Specification.Result do
  @moduledoc """
  Represents a result of a rule evaluation.

  It contains the rules and the result which was returned by the rules.
  """
  alias Specification.Types

  @type result_value :: boolean() | :ok | {:ok, any()} | {:error, any()}

  @type t :: %__MODULE__{
          rule: Types.rule() | Types.rules(),
          result: result_value()
        }
  defstruct [:rule, :result]

  def satisfied?(%__MODULE__{result: result}), do: satisfied?(result)
  def satisfied?(boolean) when is_boolean(boolean), do: boolean
  def satisfied?(:ok), do: true
  def satisfied?({:ok, _}), do: true
  def satisfied?({:error, _}), do: false
end
