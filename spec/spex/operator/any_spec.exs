defmodule Spex.Operator.AnySpec do
  use ESpec, async: true

  alias Spex.Operator.Any

  it_behaves_like Shared.EvaluateSpec,
    rule_type: Any,
    rule: Any.new([&Keyword.keyword?/1, &is_map/1]),
    valid_values: [
      [],
      [a: 1, b: 2],
      %{},
      %{foo: "bar"}
    ],
    invalid_values: [
      "l33t",
      42,
      :a,
      MapSet.new()
    ]
end
