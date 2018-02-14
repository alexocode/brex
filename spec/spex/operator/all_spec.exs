defmodule Spex.Operator.AllSpec do
  use ESpec, async: true

  alias Spex.Operator.All

  it_behaves_like Shared.EvaluateSpec,
    rule_type: All,
    rule: All.new([&is_list/1, &(length(&1) > 0)]),
    valid_values: [
      [1, 2, 3],
      [a: 1, b: 2]
    ],
    invalid_values: [
      [],
      %{},
      :a,
      MapSet.new()
    ]
end
