defmodule Spex.Operator do
  @moduledoc """
  Operators to link rules with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `none` no given rule has to be valid (`not`)

  # Custom Operators

  **TL;DR**

  1. `use Spex.Operator`
  2. define a struct with a `clauses` key (`defstruct [:clauses]`)
  3. define an `aggregator/1` function and return the aggregating function

  There are various `use` options to control this behaviour and to make your
  life easier.

  ## Options
  ### `aggregator`

  This controls the aggregator definition, it can receive:

  - a function reference: `&Enum.all?/1`
  - an anonymous function: `&Enum.all(&1)` or `fn v -> Enum.all(v) end`
  - an atom, identifying a function in this module: `:my_aggregator`
  - a tuple, identifying a function in a module: `{MyModule, :my_aggregator}`

  ### `clauses`

  Allows to override the expected default key (`clauses`) for contained
  "sub-rules".

  # How does this magic work?

  Spex operators are based on the `Spex.Operator.Aggregatable` protocol. When
  calling `use Spex.Operator` Spex tries to define a number of functions for you
  which it then uses to implement the protocol. The protocol calls then simply
  delegate to the functions in your custom operator module.

  Furthermore it defines an `evaluate/2` function which is necessary to actually
  use this operator as a Spex rule. This might change in the future, to make
  implementing the `Aggregatable` protocol sufficient for defining custom operators.

  To do all of this it calls the `Spex.Operator.Builder.build_from_use/1`
  function, which does a number of things.

  1. it defines an `aggregator/1` function, if an `aggregator` option has been given
  2. it defines a `clauses/1` function, which extracts the clauses from the struct

  After that it tries to define the implementation of the `Aggregatable`
  protocol, which simply delegates it's calls to the using module.

  Due to that it checks if the necessary functions (`aggregator/1` and
  `clauses/1`) exist. In case they don't exist, a `CompileError` is being raised.
  """

  alias Spex.Types

  # A struct implementing this behaviour
  @type t :: struct()

  @type clauses :: list(Types.rule())

  defprotocol Aggregatable do
    @spec aggregator(t()) :: (list(boolean()) -> boolean())
    def aggregator(rule)

    @spec clauses(t()) :: list(Spex.Types.rule())
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

    @spec unquote(link)(Types.rule(), Types.rule()) :: t()
    def unquote(link)(arg1, arg2) do
      unquote(link)([arg1, arg2])
    end

    def operator?(%{__struct__: unquote(module)}), do: true

    def type_for(operator: unquote(link)), do: unquote(module)
  end

  @spec operator?(t()) :: boolean()
  def operator?(_), do: false

  @spec type_for(operator: atom()) :: nil | module()
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
