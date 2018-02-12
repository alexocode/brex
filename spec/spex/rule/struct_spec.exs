defmodule Spex.Rule.StructSpec do
  use ESpec, async: true

  defmodule EqualsRule do
    use Spex.Rule.Struct

    defstruct [:value]

    @impl Spex.Rule.Struct
    def evaluate(%__MODULE__{value: expected}, value) do
      expected == value
    end
  end

  let rule_type: described_module()

  it_behaves_like Shared.IsRuleSpec,
    valid_rules: [
      %EqualsRule{value: 42}
    ],
    invalid_rules: [
      :a,
      1,
      &is_list/1,
      Spex.Operator.all([]),
      Support.SomeModuleRule
    ]

  it_behaves_like Shared.EvaluateSpec,
    rule: %EqualsRule{value: 42},
    valid_values: [
      42,
      42.0
    ],
    invalid_values: [
      1,
      1337,
      :a,
      "foo"
    ]
end
