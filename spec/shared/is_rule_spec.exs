defmodule Shared.IsRuleSpec do
  use ESpec, async: true, shared: true

  import Specification.Assertions.Rule

  let_overridable :rule_type
  let_overridable :valid_rules
  let_overridable :invalid_rules

  describe ".is_rule?" do
    context "for valid rules" do
      it "be rules" do
        valid_rules()
        |> List.wrap()
        |> Enum.each(fn rule ->
          expect rule |> to(be_rule(rule_type()))
        end)
      end
    end

    context "for invalid rules" do
      it "should return false" do
        invalid_rules()
        |> List.wrap()
        |> Enum.each(fn rule ->
          expect rule |> to_not(be_rule(rule_type()))
        end)
      end
    end
  end
end
