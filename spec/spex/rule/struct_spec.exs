defmodule Spex.Rule.StructSpec do
  use ESpec, async: true

  alias Support.Rules.EqualsRule

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
