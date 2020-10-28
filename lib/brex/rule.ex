defmodule Brex.Rule do
  @moduledoc """
  The behaviour for module based rules which requires an `evaluate/1` function.
  Also offers some helpful functions to deal with all kinds of rules.

  Furthermore contains the `Brex.Rule.Evaluable` protocol which represents the
  basic building block of `Brex`. Currently supported rule types are:

  - `atom` or rather Modules
  - `function` with arity 1
  - `struct`s, take a look at `Brex.Rule.Struct` for details

  # Example - Module based rule

      defmodule OkRule do
        @behaviour Brex.Rule

        @impl Brex.Rule
        def evaluate(:ok), do: true

        @impl Brex.Rule
        def evaluate({:ok, _}), do: true

        @impl Brex.Rule
        def evaluate(_), do: false
      end

  """
  alias Brex.Types

  @type t :: any()

  @callback evaluate(value :: Types.value()) :: Types.evaluation()

  defprotocol Evaluable do
    @moduledoc """
    The main rule protocol. Each rule needs to implement this protocol to be
    considered a rule.

    Take a look at `Brex.Rule.Struct` for details on implementing struct based
    custom rules.
    """

    @spec evaluate(t(), Types.value()) :: Types.evaluation()
    def evaluate(rule, value)
  end

  @doc """
  Calls `evaluate/2` with the given rule and value and wraps it in a
  `Brex.Result` struct.
  """
  @spec evaluate(t(), Types.value()) :: Types.result()
  def evaluate(rule, value) do
    %Brex.Result{
      evaluation: Evaluable.evaluate(rule, value),
      rule: rule,
      value: value
    }
  end

  @doc """
  Returns the type or rather the implementation module for
  `Brex.Rule.Evaluable`.

  ## Examples

      iex> Brex.Rule.type(&is_list/1)
      Brex.Rule.Evaluable.Function

      iex> Brex.Rule.type(SomeModuleRule)
      Brex.Rule.Evaluable.Atom

      iex> Brex.Rule.type(Brex.all([]))
      Brex.Rule.Evaluable.Brex.Operator

      iex> Brex.Rule.type("something")
      nil

  """
  @spec type(t()) :: module() | nil
  def type(rule), do: Evaluable.impl_for(rule)

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

      iex> Brex.Rule.number_of_clauses([])
      0

      iex> rules = [fn _ -> true end]
      iex> Brex.Rule.number_of_clauses(rules)
      1

      iex> rules = [fn _ -> true end, Brex.any(fn _ -> false end, fn _ -> true end)]
      iex> Brex.Rule.number_of_clauses(rules)
      3

  """
  @spec number_of_clauses(t() | list(t())) :: non_neg_integer()
  def number_of_clauses(rules) when is_list(rules) do
    rules
    |> Enum.map(&number_of_clauses/1)
    |> Enum.sum()
  end

  def number_of_clauses(rule) do
    case Brex.Operator.clauses(rule) do
      {:ok, clauses} -> number_of_clauses(clauses)
      :error -> 1
    end
  end
end
