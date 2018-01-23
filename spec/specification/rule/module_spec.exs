defmodule Specification.Rule.ModuleSpec do
  use ESpec, async: true

  defmodule NotNilRule do
    @behaviour Specification.Rule.Module

    @impl Specification.Rule.Module
    def evaluate(value) do
      not is_nil(value)
    end
  end

  let rule_type: described_module()

  it_behaves_like Shared.IsRuleSpec,
    valid_rules: [
      NotNilRule
    ],
    invalid_rules: [
      :a,
      1,
      &is_list/1,
      Specification.Operator.all([])
    ]

  it_behaves_like Shared.EvaluateSpec,
    rule: NotNilRule,
    valid_values: [
      %{},
      :a,
      MapSet.new()
    ],
    invalid_values: [
      nil
    ]
end
