defmodule Support.SomeModuleRule do
  @behaviour Specification.Rule.Module

  @impl Specification.Rule.Module
  def evaluate(value) do
    not is_nil(value)
  end
end
