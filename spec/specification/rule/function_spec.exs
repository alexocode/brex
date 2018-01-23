defmodule Specification.Rule.FunctionSpec do
  use ESpec, async: true

  it_behaves_like Shared.IsRuleSpec,
    rule_type: described_module(),
    valid_rules: [
      &is_list/1,
      fn _ -> true end
    ],
    invalid_rules: [
      :a,
      1,
      Support.SomeModuleRule,
      Specification.Operator.all([])
    ]
end
