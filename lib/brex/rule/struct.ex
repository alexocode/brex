defmodule Brex.Rule.Struct do
  @moduledoc """
  Easily define your own struct based rules by *using* `#{inspect(__MODULE__)}`.

  It takes care of implementing `Brex.Rule.Evaluable` for you, as long as you
  define an `evaluate/2` function receiving your struct and the value to
  evaluate.

  # Example

      defmodule EqualRule do
        use #{inspect(__MODULE__)}

        defstruct [:expected]

        def evaluate(%__MODULE__{expected: expected}, actual) do
          expected == actual
        end
      end
  """

  # A struct implementing this behaviour
  @type t :: struct()

  defmacro __using__(_opts) do
    quote do
      @after_compile unquote(__MODULE__)
    end
  end

  def __after_compile__(%{module: module} = env, _bytecode) do
    is_struct_module(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} which is not a struct"

    defimpl_evaluable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} without defining evaluate/2"
  end

  defp is_struct_module(module) do
    function_exported?(module, :__struct__, 0) and function_exported?(module, :__struct__, 1)
  end

  defp defimpl_evaluable(module) do
    if function_exported?(module, :evaluate, 2) do
      defimpl Brex.Rule.Evaluable, for: module do
        defdelegate evaluate(rule, value), to: module
      end
    end
  end
end
