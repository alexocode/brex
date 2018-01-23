defmodule Specification.Rule.Struct do
  @moduledoc """
  This module contains the behaviour to specify a Specification rule with some
  state by making use of structs.

  You can __use__ this module to define your own struct based rules:

      defmodule MyRule do
        use #{inspect(__MODULE__)}

        defstruct [:my_field]

        def evaluate(%__MODULE__{my_field: foo}, value) do
          foo != value
        end
      end
  """
  use Specification.Rule

  alias Specification.Types

  @callback evaluate(struct(), Types.value()) :: Types.result()

  defmacro __using__(_which) do
    quote location: :keep do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    # include default fallback functions at end, with lowest precedence
    quote generated: true, location: :keep do
      def is_rule?(%__MODULE__{}), do: true
      def is_rule?(_other), do: false

      def evaluate(other, value) do
        {:error, {:non_matching_other_value, other, value}}
      end
    end
  end

  def is_rule?(%_{} = struct) do
    module = struct.__struct__

    function_exported?(module, :is_rule?, 1) and module.is_rule?(struct)
  end

  def evaluate(struct, value) do
    struct.__struct__.evaluate(struct, value)
  end
end
