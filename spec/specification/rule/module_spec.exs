defmodule Specification.Rule.ModuleSpec do
  use ESpec, async: true

  defmodule NotNilRule do
    use Specification.Rule.Module

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

  defmodule RaisingRule do
    use Specification.Rule.Module

    @impl true
    def evaluate(_value) do
      raise "Ain't nobody got time for that!"
    end
  end

  it_behaves_like Shared.EvaluateSpec,
    rule: RaisingRule,
    valid_values: [],
    invalid_values: [
      1,
      :"2",
      "3",
      %{4 => 5},
      [6, 7]
    ]

  defmodule ThrowingRule do
    use Specification.Rule.Module

    @impl true
    def evaluate(value), do: throw(value)
  end

  it_behaves_like Shared.EvaluateSpec,
    rule: ThrowingRule,
    valid_values: [],
    invalid_values: [
      1,
      :"2",
      "3",
      %{4 => 5},
      [6, 7]
    ]
end
