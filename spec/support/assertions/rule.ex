defmodule Specification.Assertions.Rule do
  @moduledoc false

  alias Specification.Assertions.Rule.{BeRule, SatisfyRule}

  def be_rule(rule \\ nil), do: {BeRule, rule}

  def satisfy_rule(rule, of_type: type), do: {SatisfyRule, {rule, type}}
  def satisfy_rule(rule), do: satisfy_rule(rule, of_type: nil)
end
