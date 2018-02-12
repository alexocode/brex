defmodule Specification.Operator do
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

  defprotocol Linkable do
    @spec clauses(Specification.Operator.t()) :: Specification.Operator.clauses()
    def clauses(operator)

    # @spec link(Specification.Operator.t()) :: Specification.Operator.link()
    # def link(operator)

    @spec passed?(list(boolean())) :: boolean()
    def passed?(results)
  end

  @callback new(clauses()) :: t()
  @callback clauses(t()) :: clauses()
  # @callback link(Specification.Operator.t()) :: Specification.Operator.link()
  @callback passed?(list(boolean())) :: boolean()

  @links [:all, :any, :none]

  for link <- @links do
    camelized_link =
      link
      |> Atom.to_string()
      |> Macro.camelize()
      |> String.to_atom()

    link_module = Module.concat(Linkable, camelized_link)

    @spec unquote(link)(clauses()) :: t()
    def unquote(link)(clauses) do
      unquote(link_module).new(clauses)
    end

    @spec unquote(link)(clause(), clause()) :: t()
    def unquote(link)(arg1, arg2) do
      unquote(link)([arg1, arg2])
    end
  end

  defp link_to_module(link) do
    camelized_link =
      link
      |> Atom.to_string()
      |> Macro.camelize()
      |> String.to_atom()

    Module.concat(__MODULE__)
  end

  @spec clauses(t()) :: clauses()
  defdelegate clauses(operator), to: Linkable

  @spec operator?(t()) :: boolean()
  def operator?(operator), do: Linkable.impl_for(operator) != nil
end
