defmodule Specification.Rule do
  @moduledoc false

  alias Specification.Types

  @type t :: module()

  @callback evaluate(Types.value()) :: Types.result()

  def evaluate(rule, value) do
    if is_rule?(rule) do
      do_evaluate(rule, value)
    else
      raise ArgumentError, "Invalid rule: #{inspect(rule)}"
    end
  end

  def is_rule?(rule) when is_atom(rule) do
    function_exported?(rule, :evaluate, 1)
  end

  def is_rule(_rule) do
    false
  end

  defp do_evaluate(rule, value) do
    rule.evaluate(value)
  catch
    error -> {:error, error}
  rescue
    error -> {:error, error}
  end
end
