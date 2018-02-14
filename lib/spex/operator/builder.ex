defmodule Spex.Operator.Builder do
  def build_from_use(opts) do
    aggregator = Keyword.get(opts, :aggregator)
    rules = Keyword.get(opts, :rules) || Keyword.get(opts, :clauses) || :rules

    quote do
      @after_compile unquote(__MODULE__)
      @behaviour Spex.Operator

      use Spex.Rule.Struct

      unquote(build(:aggregator, aggregator))
      unquote(build(:clauses, rules))
      unquote(build(:new, rules))

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
          |> Enum.map(&Spex.result(&1, value))

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
      def new(rules), do: struct(__MODULE__, %{unquote(key) => rules})
    end
  end

  defp build(option, value) do
    raise ArgumentError, "Invalid value for option: #{inspect(option)}=#{inspect(value)}"
  end

  def __after_compile__(%{module: module} = env, _bytecode) do
    defimpl_nestable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use Spex.Operator " <>
            "on module #{inspect(module)} without defining aggregator/1 and clauses/1"
  end

  defp defimpl_nestable(module) do
    if function_exported?(module, :aggregator, 1) and function_exported?(module, :clauses, 1) do
      defimpl Spex.Operator.Aggregatable, for: module do
        defdelegate aggregator(rule), to: module
        defdelegate clauses(rule), to: module
      end
    end
  end
end
