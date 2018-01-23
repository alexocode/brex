defmodule Specification.Assertions.Rule do
  @moduledoc false

  alias Specification.Assertions.Rule.BeRule

  def be_rule(rule \\ nil), do: {BeRule, rule}
end
