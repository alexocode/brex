defmodule Spex.Operator.Struct do
  defmacro __using__(opts) do
    key_to_clauses =
      Keyword.get(opts, :key_to_clauses, :clauses) ||
        raise "can't use #{inspect(__MODULE__)} with `key_to_clauses` being nil!"

    quote do
      use Spex.Rule.Struct

      @behaviour Spex.Operator

      def new(clauses), do: struct(__MODULE__, %{unquote(key_to_clauses) => clauses})
      def clauses(%{unquote(key_to_clauses) => clauses}), do: clauses

      def evaluate(operator, value) do
        reduce_clauses(operator, with: &Spex.evaluate(&1, value))
      end

      def result(operator, value) do
        results = reduce_clauses(operator, with: &Spex.result(&1, value))

        %Spex.Result{
          rule: operator,
          evaluation: results,
          value: value
        }
      end

      defp reduce_clauses(operator, with: transformer) do
        transformed = map_clauses(operator, with: transformer)

        transformed
        |> Enum.map(&Spex.passed?/1)
        |> passed?()
        |> if do
          {:ok, transformed}
        else
          {:error, transformed}
        end
      end

      defp map_clauses(operator, with: transformer) do
        operator
        |> clauses()
        |> Enum.map(transformer)
      end

      def nested_rules(operator), do: clauses(operator)

      defimpl Spex.Operator.Linkable, for: __MODULE__ do
        defdelegate clauses(operator), to: __MODULE__
        defdelegate passed?(results), to: __MODULE__
      end

      defoverridable clauses: 1
    end
  end
end
