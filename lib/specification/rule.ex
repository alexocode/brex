defmodule Specification.Rule do
  defprotocol Evaluate do
    @fallback_to_any false

    @spec evaluate(t(), Types.value()) :: Types.evaluation()
    def evaluate(rule, value)
  end

  defprotocol Result do
    @fallback_to_any true

    @spec result(t(), Types.value()) :: Types.result()
    def result(rule, value)
  end

  defprotocol NumberOfClauses do
    @fallback_to_any true

    @spec number_of_clauses(t() | list(t())) :: non_neg_integer()
    def number_of_clauses(rule)
  end

  # One __could__ generate this: but that would require writing a recursive AST generating macro, so nope
  # @type t :: Rule.Function.t() | Rule.Module.t() | Rule.Operator.t() | Rule.Struct.t()
  @type t :: any()

  defmacro __using__(_which) do
    quote do: @after_compile({Specification.Rule.Decorator, :decorate})
  end

  @spec evaluate(t(), Types.value()) :: Types.evaluation()
  defdelegate evaluate(rule, value), to: Evaluate

  @spec result(t(), Types.value()) :: Types.result()
  defdelegate result(rule, value), to: Result

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

  iex> Specification.Rule.number_of_clauses([])
  0

  iex> rules = [fn _ -> true end]
  iex> Specification.Rule.number_of_clauses(rules)
  1

  iex> rules = [fn _ -> true end, Specification.Operator.any(fn _ -> false end, fn _ -> true end)]
  iex> Specification.Rule.number_of_clauses(rules)
  3
  """
  @spec number_of_clauses(t() | list(t())) :: non_neg_integer()
  defdelegate number_of_clauses(rule), to: NumberOfClauses
end

defmodule Specificaiton.Rule.Decorator do
  alias Specification.Rule

  def decorate(%{module: module} = env, _bytecode) do
    defimpl_evaluate(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} without defining evaluate/2"

    defimpl_result(module)
    defimpl_number_of_clauses(module)
  end

  def defimpl_evaluate(module) do
    if function_exported?(module, :evaluate, 2) do
      defimpl Rule.Evaluate, for: module do
        defdelegate evaluate(rule, value), to: module
      end
    end
  end

  def defimpl_result(module) do
    if function_exported?(module, :result, 2) do
      defimpl Rule.Result, for: module do
        defdelegate result(rule, value), to: module
      end
    end
  end

  def defimpl_number_of_clauses(module) do
    if function_exported?(module, :number_of_clauses, 1) do
      defimpl Rule.NumberOfClauses, for: module do
        defdelegate number_of_clauses(rule), to: module
      end
    end
  end
end
