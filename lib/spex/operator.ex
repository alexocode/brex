defmodule Spex.Operator do
  @moduledoc """
  Operators to link links with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `none` no given rule has to be valid (`not`)
  """

  @type t :: any()
  @type link :: :all | :any | :none
  @type clause :: Specifiation.Types.rule()
  @type clauses :: list(clause())

  @links [
    all: Spex.Operator.All,
    any: Spex.Operator.Any,
    none: Spex.Operator.None
  ]

  for {link, module} <- @links do
    @spec unquote(link)(clauses()) :: t()
    def unquote(link)(clauses) do
      unquote(module).new(clauses)
    end

    @spec unquote(link)(clause(), clause()) :: t()
    def unquote(link)(arg1, arg2) do
      unquote(link)([arg1, arg2])
    end

    @spec operator?(t()) :: boolean()
    def operator?(%{__struct__: unquote(module)}), do: true
  end

  def operator?(_), do: false

  @spec clauses(t()) :: clauses()
  defdelegate clauses(operator), to: Spex.Rule.Nestable, as: :nested_rules
end
