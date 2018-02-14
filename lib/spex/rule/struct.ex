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

  # A struct implementing this behaviour
  @type t :: struct()

  defmacro __using__([]) do
    quote do
      @after_compile unquote(__MODULE__)
    end
  end

  defmacro __using__(opts) do
    if is_nested?(opts) do
      quote do: use(Spex.Rule.Operator, unquote(opts))
    else
      quote do: use(unquote(__MODULE__))
    end
  end

  defp is_nested?(opts) do
    if Keyword.get(opts, :nested), do: true, else: false
  end

  def __after_compile__(%{module: module} = env, _bytecode) do
    defimpl_evaluable(module) ||
      raise CompileError,
        file: env.file,
        line: env.line,
        description:
          "cannot use #{inspect(__MODULE__)} on module #{inspect(module)} without defining evaluate/2"
  end

  defp defimpl_evaluable(module) do
    if function_exported?(module, :evaluate, 2) do
      defimpl Spex.Rule.Evaluable, for: module do
        defdelegate evaluate(rule, value), to: module
      end
    end
  end
end
