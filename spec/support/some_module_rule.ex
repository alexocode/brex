defmodule Support.SomeModuleRule do
  @moduledoc false

  use Spex.Rule.Module

  @impl Spex.Rule.Module
  def evaluate(value) do
    not is_nil(value)
  end
end
