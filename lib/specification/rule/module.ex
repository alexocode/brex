defmodule Specification.Rule.Module do
  use Specification.Rule

  alias Specification.Types

  @callback evaluate(Types.value()) :: Types.result()

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
