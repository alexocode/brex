defmodule Spex.Operator do
  @moduledoc """
  Operators to link links with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `none` no given rule has to be valid (`not`)
  """

  # A struct implementing this behaviour
  @type t :: struct()

  @type clause :: Specifiation.Types.rule()
  @type clauses :: list(clause())

  @callback new(clauses()) :: t()
  @callback aggregator(t()) :: (list(boolean()) -> boolean())
  @callback clauses(t()) :: list(Spex.Types.rule())

  defprotocol Aggregatable do
    @spec aggregator(t()) :: (list(boolean()) -> boolean())
    def aggregator(rule)

    @spec clauses(t()) :: list(t())
    def clauses(rule)
  end

  defmacro __using__(opts) do
    Spex.Operator.Builder.build_from_use(opts)
  end

  operators = [
    all: Spex.Operator.All,
    any: Spex.Operator.Any,
    none: Spex.Operator.None
  ]

  def links, do: unquote(Keyword.keys(operators))

  for {link, module} <- operators do
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

    def type_for(operator: unquote(link)), do: unquote(module)
  end

  def operator?(_), do: false

  def type_for(_), do: nil

  @doc """
  Returns the rules contained in the Operator. Raises a `Protocol.UndefinedError`
  if the given value does not implement `Spex.Operator.Aggregatable`.

  ## Examples

      iex> Spex.Operator.clauses!(Spex.Operator.all([&is_list/1, &is_map/1]))
      [&is_list/1, &is_map/1]
  """
  @spec clauses!(t()) :: clauses()
  defdelegate clauses!(operator), to: Aggregatable, as: :clauses

  @doc """
  Returns `{:ok, list(t())}` if the rule implements Spex.Operator.Aggregatable
  and `:error` otherwise.

  ## Examples

      iex> Spex.Operator.clauses(Spex.Operator.all([&is_list/1, &is_map/1]))
      {:ok, [&is_list/1, &is_map/1]}

      iex> Spex.Operator.clauses(&is_list/1)
      :error

      iex> Spex.Operator.clauses("foo_bar")
      :error
  """
  @spec clauses(t()) :: {:ok, clauses()} | :error
  def clauses(operator) do
    case Aggregatable.impl_for(operator) do
      nil -> :error
      impl -> {:ok, impl.clauses(operator)}
    end
  end
end
