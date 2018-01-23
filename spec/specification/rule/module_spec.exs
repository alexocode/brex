defmodule Specification.Rule.ModuleSpec do
  use ESpec, async: true

  it_behaves_like Shared.IsRuleSpec,
    rule_type: described_module(),
    valid_rules: [
      Support.SomeModuleRule
    ],
    invalid_rules: [
      :a,
      1,
      &is_list/1,
      Specification.Operator.all([])
    ]
end
