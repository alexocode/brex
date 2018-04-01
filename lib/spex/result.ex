defmodule Spex.Result do
  @moduledoc """
  Represents a result of a rule evaluation. It contains ...

  - `evaluation`: the result of the `evaluate` call for the
  - `rule`: the evaluated rule
  - `value`: the evaluated value

  In addition to that it defines a `passed?/1` function which receives a
  `Spex.Result` or an `evaluate` return value and determines whether the
  evaluations was considered successful or not.
  """
  alias Spex.Types

  @type evaluation :: success() | failure()
  @type success :: true | :ok | {:ok, any()}
  @type failure :: false | :error | {:error, any()}
  @type rule :: Types.rule()
  @type value :: Types.value()

  @type t :: %__MODULE__{
          evaluation: evaluation(),
          rule: rule(),
          value: value()
        }
  defstruct [:evaluation, :rule, :value]

  @spec passed?(result :: t() | evaluation()) :: boolean()
  def passed?(%__MODULE__{evaluation: result}), do: passed?(result)

  def passed?(boolean) when is_boolean(boolean), do: boolean

  def passed?(:ok), do: true
  def passed?({:ok, _}), do: true

  def passed?(:error), do: false
  def passed?({:error, _}), do: false
end
