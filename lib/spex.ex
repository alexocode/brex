defmodule Spex do
  @moduledoc """
  *A [Specification Pattern](https://en.wikipedia.org/wiki/Specification_pattern)
  implementation in Elixir.*

  Using `spex` you can easily

  - __define__
  - __compose__ and
  - __evaluate__

  rules at __runtime__.

  # Basics

  The lowest building stone of `Spex` is a __rule__. A rule can
  have many shapes, for example this is a rule:

      &is_list/1

  This is a rule too:

      Spex.all([&is_list/1, &(length(&1) > 0)])

  Or this:

      defmodule MyRule do
        def evaluate(:foo), do: true
        def evaluate(:bar), do: false
      end

  Also this:

      defmodule MyStruct do
        use Spex.Rule.Struct

        defstruct [:foo]

        def evaluate(%{foo: foo}, value) do
          foo == value
        end
      end

  > Enough talk about defining rules, how can I __evaluate__ them?

  Well great that you ask, that's simple too!

      Spex.satisfies? MyRule, :foo
      true

  As you can see, `Spex` is flexible and easy to use. All of this is based on
  the `Spex.Rule.Evaluable` protocol, if you're really interested, take a look
  at `Spex.Rule` which talks about the possible rule types a little bit more.

  # Operators

  Also, as you might have noticed, I used an `all/1` function in the examples
  above. This is the __compose__ part of `Spex`: it allows you to link rules
  using boolean logic.

  It currently supports:

  - `all/1`
  - `any/1`
  - `none/1`

  I think the names speak for themself.

  # More ...

  Apart from that, this module mainly serves as a utility belt for dealing with
  rules. It offers some functions to evaluate some rules, or to check if a given
  value satisfies some rules.

  But for this I would suggest to simply take a look at the functions in detail.

  I hope you enjoy using `Spex`!
  """

  alias Spex.{Operator, Rule, Types}

  @type evaluation :: Types.evaluation()
  @type one_or_many_results :: Types.result() | list(Types.result())
  @type one_or_many_rules :: Types.rule() | list(Types.rule())
  @type result :: Types.result()
  @type value :: Types.value()

  @doc """
  Evaluates a rule for a given value and returns a boolean whether or not it
  satisfies the rule. Equivalent to a `result/2` followed by a `passed?/1` call.

  # Examples

      iex> Spex.satisfies? &is_list/1, []
      true

      iex> Spex.satisfies? Spex.any(&is_list/1, &is_map/1), []
      true

      iex> Spex.satisfies? Spex.any(&is_list/1, &is_map/1), %{}
      true

      iex> Spex.satisfies? Spex.any(&is_list/1, &is_map/1), ""
      false
  """
  @spec satisfies?(one_or_many_rules(), value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> result(value)
    |> passed?()
  end

  @doc """
  Evaluates a given rule for a given value. Returns a `Spex.Result` struct which
  contains the evaluated rules, the value and - of course - the evaluation result.

  # Examples

      iex> rule = &(length(&1) > 0)
      iex> result = Spex.result(rule, [])
      iex> match? %Spex.Result{
      ...>   evaluation: false,
      ...>   rule: _,
      ...>   value: []
      ...> }, result
      true

      iex> rules = [&is_list/1, &Keyword.keyword?/1]
      iex> result = Spex.result(rules, [])
      iex> match? %Spex.Result{
      ...>   evaluation: {:ok, [%Spex.Result{evaluation: true}, %Spex.Result{}]},
      ...>   rule: %Spex.Operator.All{clauses: _},
      ...>   value: []
      ...> }, result
      true
  """
  @spec result(one_or_many_rules(), value()) :: result()
  def result(rules, value) do
    rules
    |> wrap()
    |> Rule.result(value)
  end

  defp wrap(rules) when is_list(rules) do
    Spex.all(rules)
  end

  defp wrap(rule) do
    rule
  end

  @doc """
  Allows to reduce one or many `Spex.Result` to a simple `true` or `false` boolean.

  # Examples

      iex> Spex.passed? %Spex.Result{evaluation: true}
      true

      iex> Spex.passed? %Spex.Result{evaluation: :ok}
      true

      iex> Spex.passed? %Spex.Result{evaluation: {:ok, :success}}
      true

      iex> Spex.passed? %Spex.Result{evaluation: false}
      false

      iex> Spex.passed? %Spex.Result{evaluation: :error}
      false

      iex> Spex.passed? %Spex.Result{evaluation: {:error, :failure}}
      false

      iex> Spex.passed?  %Spex.Result{evaluation: :unknown_evaluation}
      ** (FunctionClauseError) no function clause matching in Spex.Result.passed?/1
  """
  @spec passed?(one_or_many_results()) :: boolean()
  def passed?(results) do
    results
    |> List.wrap()
    |> Enum.all?(&Spex.Result.passed?/1)
  end

  @doc """
  Returns the number of "clauses" for the given rule. This is mostly interesting
  when using operators and having to decide between some matching rules based on
  how specific they are.

  # Examples

      iex> Spex.number_of_clauses &is_list/1
      1

      iex Spex.number_of_clauses Spex.none([&is_list/1, &is_map/1, &is_binary/1])
      3
  """
  @spec number_of_clauses(Types.rule()) :: non_neg_integer()
  defdelegate number_of_clauses(rule), to: Rule

  for operator <- Operator.default_operators() do
    short_name =
      operator
      |> Macro.underscore()
      |> Path.basename()
      |> String.to_atom()

    @doc "Shortcut for `Spex.#{operator}([rule1, rule2])`."
    @spec unquote(short_name)(rule1 :: Types.rule(), rule2 :: Types.rule()) :: Operator.t()
    def unquote(short_name)(rule1, rule2) do
      unquote(short_name)([rule1, rule2])
    end

    @doc """
    Links the given rules in a boolean fashion, similar to the `Enum` functions.

    - `all` rules have to pass (`and` / `&&`)
    - `any` one rule is sufficient to pass (`or` / `||`)
    - `none` of the rules may pass (`not` / `!`)

    # Examples

        iex> Spex.#{short_name} &is_list/1, &is_map/1
        %#{inspect(operator)}{
          clauses: [&:erlang.is_list/1, &:erlang.is_map/1]
        }

        iex> Spex.#{short_name} [&is_list/1, &is_map/1, &is_binary/1]
        %#{inspect(operator)}{
          clauses: [&:erlang.is_list/1, &:erlang.is_map/1, &:erlang.is_binary/1]
        }
    """
    @spec unquote(short_name)(list(Types.rule())) :: Operator.t()
    def unquote(short_name)(rules) do
      Operator.new(unquote(operator), rules)
    end
  end
end
