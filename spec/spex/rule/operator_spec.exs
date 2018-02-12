defmodule Spex.Rule.OperatorSpec do
  use ESpec, async: true

  import Spex.Operator

  defmodule SomeStruct do
    defstruct []
  end

  it_behaves_like Shared.IsRuleSpec,
    rule_type: described_module(),
    valid_rules: [
      all([&is_list/1, Support.SomeModuleRule]),
      any([&is_nil/1]),
      none([&is_function(&1, 1), Support.SomeModuleRule])
    ],
    invalid_rules: [
      :a,
      1,
      &is_list/1,
      fn _ -> true end,
      Support.SomeModuleRule
    ]

  describe ".all" do
    it_behaves_like Shared.EvaluateSpec,
      rule: all([&String.printable?/1, &(String.length(&1) > 0)]),
      valid_values: [
        "foo",
        "bar",
        "baz"
      ],
      invalid_values: [
        "",
        <<0>> <> "foo"
      ]
  end

  describe ".any" do
    it_behaves_like Shared.EvaluateSpec,
      rule: any([&Keyword.keyword?/1, &is_map/1]),
      valid_values: [
        %{},
        [],
        MapSet.new(),
        %SomeStruct{},
        [a: 1]
      ],
      invalid_values: [
        [1, 2, 3],
        "foo",
        :foo
      ]
  end

  describe ".none" do
    it_behaves_like Shared.EvaluateSpec,
      rule: none([&is_binary/1, &is_atom/1]),
      valid_values: [
        %{},
        [1, 2, 3],
        %SomeStruct{},
        1.5,
        1
      ],
      invalid_values: [
        "foo",
        <<0>> <> "bar",
        SomeStruct,
        List,
        :foo
      ]
  end
end
