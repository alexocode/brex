defmodule Specification.Rule.OperatorSpec do
  use ESpec, async: true

  it_behaves_like Shared.IsRuleSpec,
    rule_type: described_module(),
    valid_rules: [
      Specification.Operator.all([&is_list/1, Support.SomeModuleRule]),
      Specification.Operator.any([&is_nil/1]),
      Specification.Operator.none([&is_function(&1, 1), Support.SomeModuleRule])
    ],
    invalid_rules: [
      :a,
      1,
      &is_list/1,
      fn _ -> true end,
      Support.SomeModuleRule
    ]
end
