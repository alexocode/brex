defmodule Specification.Rule do
  @moduledoc false

  alias Specification.Types

  @type t :: module()

  @callback evaluate(Types.value()) :: Types.result()

  def evaluate(rule, value) do
    if is_rule?(rule) do
      rule.evaluate(value)
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
end
