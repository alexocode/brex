defmodule Brex.Rule.ModuleSpec do
  use ESpec, async: true

  defmodule NotNilRule do
    def evaluate(value) do
      not is_nil(value)
    end
  end

  it_behaves_like Shared.IsRuleSpec,
    rule_type: Brex.Rule.Evaluable.Atom,
    valid_rules: [
      NotNilRule
    ],
    invalid_rules: [
      1,
      &is_list/1,
      Brex.all([])
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

  describe "an arbitrary atom" do
    subject do: evaluate(:an_arbitrary_atom, :anything)

    it "should raise an UndefinedFunctionError" do
      expect (&subject/0) |> to(raise_exception UndefinedFunctionError)
    end
  end

  defmodule InvalidRule do
    # No `evaluate/1`
  end

  describe "a raising module rule" do
    subject do: evaluate(InvalidRule, :anything)

    it "should raise an UndefinedFunctionError" do
      expect (&subject/0) |> to(raise_exception UndefinedFunctionError)
    end
  end

  defmodule RaisingRule do
    def evaluate(_value) do
      raise "Ain't nobody got time for that!"
    end
  end

  describe "a raising module rule" do
    subject do: evaluate(RaisingRule, :anything)

    it "should raise an error" do
      expect (&subject/0) |> to(raise_exception())
    end
  end

  defmodule ThrowingRule do
    def evaluate(value), do: throw(value)
  end

  describe "a throwing module rule" do
    subject do: evaluate(ThrowingRule, :anything)

    it "should throw something" do
      expect (&subject/0) |> to(throw_term())
    end
  end

  defp evaluate(rule, value) do
    Brex.Rule.Evaluable.evaluate(rule, value)
  end
end
