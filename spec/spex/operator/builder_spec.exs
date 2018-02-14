defmodule Spex.Operator.BuilderSpec do
  use ESpec, async: true

  alias Support.Operators

  describe "invalid Operator rules" do
    context "with no options" do
      let :invalid_rule do
        defmodule NoOptions do
          use Spex.Operator
        end
      end

      it "should raise a CompileError" do
        expect (&invalid_rule/0) |> to(raise_exception CompileError)
      end
    end

    context "with no aggregator but a clauses option" do
      let :invalid_rule do
        defmodule ClausesButNoAggregator do
          use Spex.Operator, clauses: :foo
        end
      end

      it "should raise a CompileError" do
        expect (&invalid_rule/0) |> to(raise_exception CompileError)
      end
    end
  end

  defmodule ValidOperatorRule do
    use ESpec, async: true, shared: true

    import Spex.Assertions.Rule

    let_overridable :rule_module
    let_overridable :clauses

    let_overridable rule: struct(rule_module(), %{clauses: clauses()})

    it "should be a rule" do
      expect rule() |> to(be_rule())
    end

    it "should contain the clauses" do
      rule()
      |> Spex.Operator.Aggregatable.clauses()
      |> should(eq clauses())
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

  let clauses: [&is_list/1, &(length(&1) > 0)]

  operators = %{
    "a nested rule with both options" => Operators.BothOptions,
    "a nested rule with only aggregator option and clauses definition" =>
      Operators.AggregatorOptionAndClausesDefintion,
    "a nested rule with only aggregator option no definitions" =>
      Operators.AggregatorOptionAndNoDefintion,
    "a nested rule with only clauses option and aggregator definition" =>
      Operators.ClausesOptionAndAggregatorDefintion,
    "a nested rule with no options and aggregator and clauses definitions" =>
      Operators.NoOptionAndBothDefintions
  }

  for {desc, module} <- operators do
    describe desc do
      it_behaves_like ValidOperatorRule, rule_module: unquote(module)
    end
  end
end
