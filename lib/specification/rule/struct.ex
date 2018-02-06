defmodule Specification.Rule.Struct do
  @moduledoc """
  This module contains the behaviour to specify a Specification rule with some
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
  alias Specification.{Rule, Types}

  # A struct implementing this behaviour
  @type t :: struct()

  defmacro __using__(_which) do
    quote do: @after_compile(unquote(__MODULE__))
  end

  def __after_compile__(%{module: module} = env, _bytecode) do
    defimpl_evaluate(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} without defining evaluate/2"

    defimpl_result(module)
    defimpl_number_of_clauses(module)
  end

  defp defimpl_evaluate(module) do
    if function_exported?(module, :evaluate, 2) do
      defimpl Rule.Evaluate, for: module do
        defdelegate evaluate(rule, value), to: module
      end
    end
  end

  defp defimpl_result(module) do
    if function_exported?(module, :result, 2) do
      defimpl Rule.Result, for: module do
        defdelegate result(rule, value), to: module
      end
    end
  end

  defp defimpl_number_of_clauses(module) do
    if function_exported?(module, :number_of_clauses, 1) do
      defimpl Rule.NumberOfClauses, for: module do
        defdelegate number_of_clauses(rule), to: module
      end
    end
  end
end
