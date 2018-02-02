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

  # A struct implementing this behaviour
  @type t :: struct()

  defmacro __using__(_which) do
    quote location: :keep do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    # include default fallback functions at end, with lowest precedence
    quote generated: true, location: :keep do
      def evaluate(other, value) do
        {:error, {:non_matching_other_value, other, value}}
      end
    end
  end

  @impl Specification.Rule
  def is_rule_of_type?(%_{} = struct) do
    function_exported?(struct.__struct__, :evaluate, 2)
  end

  @impl Specification.Rule
  def evaluate(struct, value) do
    struct.__struct__.evaluate(struct, value)
  end
end
