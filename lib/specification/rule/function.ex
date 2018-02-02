defmodule Specification.Rule.Function do
  @moduledoc """
  This rule type contains the logic to evaluate function based rules such as
  `&is_map/1`.

  It takes this functions and calls them with the given value. In addition it
  catches any `raise`d errors or `throw`n terms and wraps them in an `:error` tuple.
  """
  use Specification.Rule

  alias Specification.Types

  @type t :: (Types.value() -> Types.evaluation())

  @impl Specification.Rule
  def is_rule_of_type?(rule) do
    is_function(rule, 1)
  end

  @impl Specification.Rule
  def evaluate(rule, value) do
    rule.(value)
  catch
    error -> {:error, error}
  rescue
    error -> {:error, error}
  end
end
