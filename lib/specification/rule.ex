defmodule Specification.Rule do
  alias Specification.{Rule, Types}

  # A module implementing this behaviour
  @type t :: module()

  @callback is_rule?(any()) :: boolean()
  @callback evaluate(t(), Types.value()) :: Types.result()

  defmacro __using__(_which) do
    quote do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def is_rule?(_other), do: false
    end
  end

  @rule_types [
    Rule.Function,
    Rule.Module,
    Rule.Operator,
    Rule.Struct
  ]

  def is_rule?(rule) do
    Enum.any?(@rule_types, &apply(&1, :is_rule?, [rule]))
  end

  def evaluate(rule, value) do
    @rule_types
    |> Enum.find(fn type ->
      type.is_rule?(rule)
    end)
    |> case do
      nil -> invalid_rule!(rule)
      type -> type.evaluate(rule, value)
    end
  end

  defp invalid_rule!(rule) do
    raise ArgumentError, "Invalid rule: #{inspect(rule)}"
  end
end
