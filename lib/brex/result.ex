defmodule Brex.Result do
  @moduledoc """
  Represents a result of a rule evaluation. It contains ...

  - `evaluation`: the result of the `evaluate` call for the
  - `rule`: the evaluated rule
  - `value`: the evaluated value

  In addition to that it defines a `passed?/1` function which receives a
  `Brex.Result` or an `evaluate` return value and determines whether the
  evaluations was considered successful or not.
  """
  alias Brex.Types

  @type evaluation :: boolean() | any()
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

  def passed?(other) do
    Brex.satisfies?(other, success_rule()) or not 
  end

  defp failure_rule, do: Brex.any(Application.fetch_env!(:brex, :failure_rules))
  defp success_rule, do: Brex.any(Application.fetch_env!(:brex, :success_rules))
end
