defmodule Specification.Rule.Module do
  use Specification.Rule

  alias Specification.Types

  @callback evaluate(Types.value()) :: Types.result()

  defmacro __using__(_which) do
    quote location: :keep do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    # include default fallback functions at end, with lowest precedence
    quote generated: true, location: :keep do
      def evaluate(value) do
        {:error, {:non_matching_value, value}}
      end
    end
  end

  @impl Specification.Rule
  def is_rule?(rule) when is_atom(rule) do
    function_exported?(rule, :evaluate, 1)
  end

  @impl Specification.Rule
  def evaluate(rule, value) do
    rule.evaluate(value)
  catch
    error -> {:error, error}
  rescue
    error -> {:error, error}
  end
end
