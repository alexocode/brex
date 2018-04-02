defmodule Spex.Operator.Builder do
  @moduledoc false

  def build_from_use(opts) do
    aggregator = Keyword.get(opts, :aggregator)
    clauses = Keyword.get(opts, :clauses, :clauses)

    quote do
      @after_compile unquote(__MODULE__)

      use Spex.Rule.Struct

      unquote(build(:aggregator, aggregator))
      unquote(build(:clauses, clauses))
      unquote(build(:new, clauses))

      def aggregate(rule, results) do
        aggregator_fn = __MODULE__.aggregator(rule)

        results
        |> Enum.map(&Spex.passed?/1)
        |> aggregator_fn.()
      end

      def evaluate(rule, value) do
        results =
          rule
          |> clauses()
          |> Enum.map(&Spex.evaluate(&1, value))

        if aggregate(rule, results) do
          {:ok, results}
        else
          {:error, results}
        end
      end

      defoverridable evaluate: 2, clauses: 1
    end
  end

  defp build(_, nil), do: nil

  defp build(:aggregator, aggregator) when is_atom(aggregator) do
    quote do
      def aggregator(_rule) do
        &apply(__MODULE__, unquote(aggregator), [&1])
      end
    end
  end

  defp build(:aggregator, {module, function}) when is_atom(module) and is_atom(function) do
    quote do
      def aggregator(_rule) do
        &apply(unquote(module), unquote(function), [&1])
      end
    end
  end

  defp build(:aggregator, {:fn, _, _} = aggregator) do
    quote do
      def aggregator(_rule), do: unquote(aggregator)
    end
  end

  defp build(:aggregator, {:&, _, _} = aggregator) do
    quote do
      def aggregator(_rule), do: unquote(aggregator)
    end
  end

  defp build(:clauses, key) when is_atom(key) do
    quote do
      def clauses(%{unquote(key) => clauses}), do: clauses
    end
  end

  defp build(:new, key) when is_atom(key) do
    quote do
      def new(operator, clauses), do: struct(operator, %{unquote(key) => clauses})
    end
  end

  defp build(option, value) do
    raise ArgumentError, "Invalid value for option `#{inspect(option)}`: #{inspect(value)}"
  end

  def __after_compile__(%{module: module} = env, _bytecode) do
    defimpl_nestable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use Spex.Operator " <>
            "on module #{inspect(module)} without defining aggregator/1 and clauses/1. " <>
            "Take a look at the `Spex.Operator` module documentation for more information."
  end

  defp defimpl_nestable(module) do
    expected_functions = [
      [:aggregator, 1],
      [:clauses, 1],
      [:new, 2]
    ]

    if Enum.all?(expected_functions, &apply(Kernel, :function_exported?, [module | &1])) do
      defimpl Spex.Operator.Aggregatable, for: module do
        defdelegate aggregator(operator), to: module
        defdelegate clauses(operator), to: module
        defdelegate new(operator, clauses), to: module
      end
    end
  end
end
