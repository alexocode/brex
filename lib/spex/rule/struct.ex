defmodule Spex.Rule.Struct do
  @moduledoc """
  This module contains the behaviour to specify a Spex rule with some
  state by making use of structs.

  # TODO: Change this!

  You can __use__ this module to define your own struct based rules:

      defmodule MyRule do
        use #{inspect(__MODULE__)}

        defstruct [:my_field]

        def evaluate(%__MODULE__{my_field: foo}, value) do
          foo != value
        end
      end
  """
  alias Spex.Rule

  # A struct implementing this behaviour
  @type t :: struct()

  defmacro __using__(opts) do
    if is_nested?(opts) do
      use_nested(opts)
    else
      use_plain()
    end
  end

  defp is_nested?(opts) do
    if Keyword.get(opts, :nested), do: true, else: false
  end

  defp use_nested(opts) do
    aggregator = Keyword.get(opts, :aggregator)
    nested = Keyword.get(opts, :nested)

    quote do
      @after_compile {unquote(__MODULE__), :__defimpl_evaluable_and_nested__}

      unquote(build(:aggregator, aggregator))
      unquote(build(:nested, nested))
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

  defp build(:aggregator, aggregator) when is_function(aggregator, 1) do
    quote do
      def aggregator(_rule), do: unquote(aggregator)
    end
  end

  defp build(:nested, true), do: nil

  defp build(:nested, key) when is_atom(key) do
    quote do
      def nested_rules(%{unquote(key) => nested_rules}), do: nested_rules
    end
  end

  defp build(option, value) do
    raise ArgumentError, "Invalid value for option: #{inspect(option)}=#{inspect(value)}"
  end

  defp use_plain do
    quote do
      @after_compile {unquote(__MODULE__), :__defimpl_evaluable__}
    end
  end

  def __defimpl_evaluable_and_nested__(%{module: module} = env, bytecode) do
    __defimpl_evaluable__(env, bytecode)

    defimpl_nestable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} with `nested` " <>
            "on module #{inspect(module)} without defining aggregator/1 and nested_rules/1"
  end

  def __defimpl_evaluable__(%{module: module} = env, _bytecode) do
    defimpl_evaluable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} without defining evaluate/2"
  end

  defp defimpl_evaluable(module) do
    if function_exported?(module, :evaluate, 2) do
      defimpl Rule.Evaluate, for: module do
        defdelegate evaluate(rule, value), to: module
      end
    end
  end

  defp defimpl_nestable(module) do
    if function_exported?(module, :aggregator, 1) and function_exported?(module, :nested, 1) do
      defimpl Rule.Nestable, for: module do
        defdelegate aggregator(rule), to: module
        defdelegate nested_rules(rule), to: module
      end
    end
  end
end
