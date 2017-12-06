defmodule Specification.Operator do
  @moduledoc false

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
