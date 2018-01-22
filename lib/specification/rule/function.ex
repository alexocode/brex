defmodule Specification.Rule.Function do
  use Specification.Rule

  @impl Specification.Rule
  def is_rule?(rule) do
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
