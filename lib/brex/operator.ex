defmodule Brex.Operator do
  @moduledoc """
  Contains the `Aggregatable` root protocol for operators, provides some helpers
  for Operators and is `use`able to define ...

  # Custom Operators

  **TL;DR**

  1. `use Brex.Operator`
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

  Brex operators are based on the `Brex.Operator.Aggregatable` protocol. When
  calling `use Brex.Operator` Brex tries to define a number of functions for you
  which it then uses to implement the protocol. The protocol calls then simply
  delegate to the functions in your custom operator module.

  Furthermore it defines an `evaluate/2` function which is necessary to actually
  use this operator as a Brex rule. This might change in the future, to make
  implementing the `Aggregatable` protocol sufficient for defining custom operators.

  To do all of this it calls the `Brex.Operator.Builder.build_from_use/1`
  function, which does a number of things.

  1. it defines an `aggregator/1` function, if an `aggregator` option has been given
  2. it defines a `clauses/1` function, which extracts the clauses from the struct
  3. it defines a `new/2` function, which news an operator with some clauses

  After that it tries to define the implementation of the `Aggregatable`
  protocol, which simply delegates it's calls to the using module.

  Due to that it checks if the necessary functions (`aggregator/1` and
  `clauses/1`) exist. In case they don't exist, a `CompileError` is being raised.
  """
  use Brex.Rule.Struct

  @type aggregator :: (list(boolean()) -> boolean())
  @type clauses :: list(Brex.Types.rule())
  @type t :: %__MODULE__{
          aggregator: aggregator(),
          clauses: clauses()
        }
  defstruct [:aggregator, :clauses]

  def evaluate(%__MODULE__{} = rule, value) do
    results = evaluate_clauses(rule, value)

    if aggregate(rule, results) do
      {:ok, results}
    else
      {:error, results}
    end
  end

  defp evaluate_clauses(%{clauses: clauses}, value) do
    Enum.map(clauses, &Brex.evaluate(&1, value))
  end

  defp aggregate(%{aggregator: aggregator}, results) do
    results
    |> Enum.map(&Brex.passed?/1)
    |> aggregator.()
  end

  def clauses(%__MODULE__{clauses: clauses}), do: {:ok, clauses}
  def clauses(_), do: :error
end
