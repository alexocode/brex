defmodule Spex.Rule.OperatorSpec do
  use ESpec, async: true

  alias Support.Rules.Operator, as: Nested

  describe "invalid Operator rules" do
    context "with no options" do
      let :invalid_rule do
        defmodule InvalidRule do
          use Spex.Rule.Operator
        end
      end

      it "should raise a CompileError" do
        expect (&invalid_rule/0) |> to(raise_exception CompileError)
      end
    end

    context "with no aggregator but a nested option" do
      let :invalid_rule do
        defmodule InvalidRule do
          use Spex.Rule.Operator, nested: :foo
        end
      end

      it "should raise a CompileError" do
        expect (&invalid_rule/0) |> to(raise_exception CompileError)
      end
    end

    context "with no nested but an aggregator option" do
      let :invalid_rule do
        defmodule InvalidRule do
          use Spex.Rule.Operator, aggregator: &Enum.all?/1
        end
      end

      it "should raise a CompileError" do
        expect (&invalid_rule/0) |> to(raise_exception CompileError)
      end
    end
  end

  defmodule ValidNestedRule do
    use ESpec, async: true, shared: true

    import Spex.Assertions.Rule

    let_overridable :rule_module
    let_overridable :nested_rules

    let_overridable rule: struct(rule_module(), %{nested: nested_rules()})

    it "should be a rule" do
      expect rule() |> to(be_rule())
    end

    it "should the nested rules" do
      rule()
      |> Spex.Rule.Nestable.nested_rules()
      |> should(eq nested_rules())
    end

    it "a non empty list should satisfy the rule" do
      expect [1, 2, 3] |> to(satisfy_rule(rule()))
    end

    it "a empty list should not satisfy the rule" do
      expect [] |> to_not(satisfy_rule(rule()))
    end

    it "a non empty map should not satisfy the rule" do
      expect %{} |> to_not(satisfy_rule(rule()))
    end

    it "a string should not satisfy the rule" do
      expect "foobar" |> to_not(satisfy_rule(rule()))
    end
  end

  let nested_rules: [&is_list/1, &(length(&1) > 0)]

  describe "a nested rule with both options" do
    let rule_module: Nested.BothOptions

    it_behaves_like ValidNestedRule
  end

  describe "a nested rule with only aggregator option and nested rules definition" do
    let rule_module: Nested.AggregatorOptionAndNestedRulesDefintion

    it_behaves_like ValidNestedRule
  end

  describe "a nested rule with only nested option and aggregator definition" do
    let rule_module: Nested.NestedOptionAndAggregatorDefintion

    it_behaves_like ValidNestedRule
  end

  describe "a nested rule with no options and aggregator and nested rules definitions" do
    let rule_module: Nested.NoOptionAndBothDefintions

    it_behaves_like ValidNestedRule
  end
end
