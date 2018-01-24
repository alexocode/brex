defmodule Support.SomeModuleRule do
  @moduledoc false

  use Specification.Rule.Module

  @impl Specification.Rule.Module
  def evaluate(value) do
    not is_nil(value)
  end
end
