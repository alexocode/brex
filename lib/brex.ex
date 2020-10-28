defmodule Brex do
  @moduledoc """
  *A [Specification Pattern](https://en.wikipedia.org/wiki/Specification_pattern)
  implementation in Elixir.*

  Using `brex` you can easily

  - __define__
  - __compose__ and
  - __evaluate__

  business rules to dynamically drive the flow of your application.

  ## Basics

  The lowest building stone of `Brex` is a __rule__. A rule can
  have many shapes, for example this is a rule:

      &is_list/1

  This is a rule too:

      Brex.all([&is_list/1, &(length(&1) > 0)])

  Or this:

      defmodule MyRule do
        def evaluate(:foo), do: true
        def evaluate(:bar), do: false
      end

  Also this:

      defmodule MyStruct do
        use Brex.Rule.Struct

        defstruct [:foo]

        def evaluate(%{foo: foo}, value) do
          foo == value
        end
      end

  ## Enough talk about defining rules, how can I _evaluate_ them?

  Well great that you ask, that's simple too!

      Brex.satisfies? MyRule, :foo # => true

  As you can see, `Brex` is flexible and easy to use. All of this is based on
  the `Brex.Rule.Evaluable` protocol, if you're really interested, take a look
  at `Brex.Rule` which talks about the possible rule types a little bit more.

  ## Operators

  Also, as you might have noticed, I used an `all/1` function in the examples
  above. It's called a `Brex.Operator` and represents the __compose__ part of
  `Brex`: it allows you to link rules using boolean logic.

  It currently supports:

  - `all/1`
  - `any/1`
  - `none/1`

  I think these names speak for themselves.

  ## More ...

  Apart from that, this module mainly serves as a utility belt for dealing with
  rules. It offers some functions to evaluate some rules, or to check if a given
  value satisfies some rules.

  But for this I would suggest to simply take a look at the functions in detail.

  I hope you enjoy using `Brex`!
  """

  alias Brex.{Operator, Rule, Types}

  @type evaluation :: Types.evaluation()
  @type one_or_many_results :: Types.result() | list(Types.result())
  @type one_or_many_rules :: Types.rule() | list(Types.rule())
  @type result :: Types.result()
  @type value :: Types.value()

  @doc """
  Evaluates a rule for a given value and returns a boolean whether or not it
  satisfies the rule. Equivalent to a `result/2` followed by a `passed?/1` call.

  Allows you to pass a list of rules which get linked calling `all/1`.

  ## Examples

      iex> Brex.satisfies? &is_list/1, []
      true

      iex> Brex.satisfies? Brex.any(&is_list/1, &is_map/1), []
      true

      iex> Brex.satisfies? Brex.any(&is_list/1, &is_map/1), %{}
      true

      iex> Brex.satisfies? Brex.any(&is_list/1, &is_map/1), ""
      false

  """
  @spec satisfies?(one_or_many_rules(), value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed?()
  end

  @doc """
  Evaluates a given rule for a given value. Returns a `Brex.Result` struct which
  contains the evaluated rules, the value and - of course - the evaluation result.

  Allows you to pass a list of rules which get linked calling `all/1`.

  ## Examples

      iex> rule = &(length(&1) > 0)
      iex> result = Brex.evaluate(rule, [])
      iex> match? %Brex.Result{
      ...>   evaluation: false,
      ...>   rule: _,
      ...>   value: []
      ...> }, result
      true

      iex> rules = [&is_list/1, &Keyword.keyword?/1]
      iex> result = Brex.evaluate(rules, [])
      iex> match? %Brex.Result{
      ...>   evaluation: {:ok, [%Brex.Result{evaluation: true}, %Brex.Result{}]},
      ...>   rule: %Brex.Operator{clauses: _},
      ...>   value: []
      ...> }, result
      true

  """
  @spec evaluate(one_or_many_rules(), value()) :: result()
  def evaluate(rules, value) do
    rules
    |> wrap()
    |> Rule.evaluate(value)
  end

  defp wrap(rules) when is_list(rules) do
    Brex.all(rules)
  end

  defp wrap(rule) do
    rule
  end

  @doc """
  Allows to reduce one or many `Brex.Result` to a simple `true` or `false` boolean.

  ## Examples

      iex> Brex.passed? %Brex.Result{evaluation: true}
      true

      iex> Brex.passed? %Brex.Result{evaluation: :ok}
      true

      iex> Brex.passed? %Brex.Result{evaluation: {:ok, :success}}
      true

      iex> Brex.passed? %Brex.Result{evaluation: false}
      false

      iex> Brex.passed? %Brex.Result{evaluation: :error}
      false

      iex> Brex.passed? %Brex.Result{evaluation: {:error, :failure}}
      false

      iex> Brex.passed?  %Brex.Result{evaluation: :unknown_evaluation}
      ** (FunctionClauseError) no function clause matching in Brex.Result.passed?/1

  """
  @spec passed?(one_or_many_results()) :: boolean()
  def passed?(results) do
    results
    |> List.wrap()
    |> Enum.all?(&Brex.Result.passed?/1)
  end

  @doc """
  Returns the number of "clauses" for the given rule. This is mostly interesting
  when using operators and having to decide between some matching rules based on
  how specific they are.

  ## Examples

      iex> Brex.number_of_clauses &is_list/1
      1

      iex Brex.number_of_clauses Brex.none([&is_list/1, &is_map/1, &is_binary/1])
      3

  """
  @spec number_of_clauses(Types.rule()) :: non_neg_integer()
  defdelegate number_of_clauses(rule), to: Rule

  operator_doc = fn operator ->
    """
    Links the given rules in a boolean fashion, similar to the `Enum` functions.

    - `all` rules have to pass (`and` / `&&`)
    - `any` one rule is sufficient to pass (`or` / `||`)
    - `none` of the rules may pass (`not` / `!`)

    ## Examples

        iex> Brex.#{operator} &is_list/1, &is_map/1
        %Brex.Operator{
          aggregator: &Brex.Operator.Aggregator.#{operator}?/1,
          clauses: [&:erlang.is_list/1, &:erlang.is_map/1]
        }

        iex> Brex.#{operator} [&is_list/1, &is_map/1, &is_binary/1]
        %Brex.Operator{
          aggregator: &Brex.Operator.Aggregator.#{operator}?/1,
          clauses: [&:erlang.is_list/1, &:erlang.is_map/1, &:erlang.is_binary/1]
        }

    """
  end

  for operator <- [:all, :any, :none] do
    @doc "Shortcut for `Brex.#{operator}([rule1, rule2])`."
    @spec unquote(operator)(rule1 :: Types.rule(), rule2 :: Types.rule()) :: Operator.t()
    def unquote(operator)(rule1, rule2) do
      unquote(operator)([rule1, rule2])
    end

    @doc operator_doc.(operator)
    @spec unquote(operator)(list(Types.rule())) :: Operator.t()
    defdelegate unquote(operator)(rules), to: Brex.Operator.Defaults
  end
end
