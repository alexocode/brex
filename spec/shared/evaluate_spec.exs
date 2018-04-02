defmodule Shared.EvaluateSpec do
  use ESpec, async: true, shared: true

  import Brex.Assertions.Rule

  let_overridable rule_type: :any
  let_overridable :rule
  let_overridable [:valid_values, :invalid_values]

  describe ".evaluate" do
    context "for valid values" do
      it "should pass evaluation" do
        valid_values()
        |> List.wrap()
        |> Enum.each(fn value ->
          expect value |> to(satisfy_rule(rule(), of_type: rule_type()))
        end)
      end
    end

    context "for invalid values" do
      it "should not pass evaluation" do
        invalid_values()
        |> List.wrap()
        |> Enum.each(fn value ->
          expect value |> to_not(satisfy_rule(rule(), of_type: rule_type()))
        end)
      end
    end
  end
end
