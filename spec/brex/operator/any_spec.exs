defmodule Brex.Operator.AnySpec do
  use ESpec, async: true

  alias Brex.Operator.Any

  it_behaves_like Shared.EvaluateSpec,
    rule_type: Any,
    rule: Brex.any(&Keyword.keyword?/1, &is_map/1),
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
      <<1, 2, 3>>
    ]
end
