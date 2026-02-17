defmodule Brex.Rule.FunctionTest do
  use ExUnit.Case, async: true

  @rule_type Brex.Rule.Evaluable.Function

  describe "rule type" do
    test "recognizes function rules" do
      Enum.each([&is_list/1, fn _ -> true end], fn rule ->
        assert Brex.Rule.type(rule) == @rule_type
      end)
    end

    test "rejects non-function rules" do
      Enum.each([:a, 1, Brex.all([])], fn rule ->
        refute Brex.Rule.type(rule) == @rule_type
      end)
    end
  end

  describe "evaluate with &is_list/1" do
    @rule &is_list/1

    test "passes for lists" do
      Enum.each([[], [1, 2, 3], [a: 1, b: 2]], fn value ->
        assert Brex.satisfies?(@rule, value)
      end)
    end

    test "fails for non-lists" do
      Enum.each([%{}, :a, MapSet.new()], fn value ->
        refute Brex.satisfies?(@rule, value)
      end)
    end
  end
end
