defmodule Brex.Assertions.Rule do
  @moduledoc false

  alias Brex.Assertions.Rule.{BeRule, SatisfyRule}

  def be_rule(rule \\ :any), do: {BeRule, rule}

  def satisfy_rule(rule, of_type: type), do: {SatisfyRule, {rule, type}}
  def satisfy_rule(rule), do: satisfy_rule(rule, of_type: :any)
end
