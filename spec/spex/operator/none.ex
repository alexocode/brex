defmodule Spex.Operator.NoneSpec do
  use ESpec, async: true

  alias Spex.Operator.None

  it_behaves_like Shared.EvaluateSpec,
    rule_type: None,
    rule:
      None.new([
        &(not String.valid?(&1)),
        &String.contains?(&1, "foo"),
        &String.contains?(&1, "bar")
      ]),
    valid_values: [
      "bazboing",
      "CELEBRATION!"
    ],
    invalid_values: [
      "foo bar baz",
      "Give me a foo! FOO! Give me a bar! BAR!"
    ]
end
