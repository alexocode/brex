defmodule Specification.Operator do
  @moduledoc """
  Operators to link rules with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `negate` no given rule has to be valid (`not`)
  """

  @type t :: {:all, value()} | {:any, value()} | {:negate, value()}
  @type value :: Specifiation.Types.rules()

  for rule <- [:all, :any, :negate] do
    def unquote(rule)(rules) do
      {unquote(rule), List.wrap(rules)}
    end

    def unquote(rule)(arg1, arg2) do
      unquote(rule)([arg1, arg2])
    end
  end
end
