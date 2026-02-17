defmodule Brex.Rule.ModuleTest do
  use ExUnit.Case, async: true

  defmodule NotNilRule do
    def evaluate(value), do: not is_nil(value)
  end

  defmodule InvalidRule do
    # No evaluate/1
  end

  defmodule RaisingRule do
    def evaluate(_value), do: raise "Ain't nobody got time for that!"
  end

  defmodule ThrowingRule do
    def evaluate(value), do: throw(value)
  end

  @rule_type Brex.Rule.Evaluable.Atom

  describe "rule type" do
    test "recognizes module rules" do
      assert Brex.Rule.type(NotNilRule) == @rule_type
    end

    test "rejects non-module rules" do
      Enum.each([1, &is_list/1, Brex.all([])], fn rule ->
        refute Brex.Rule.type(rule) == @rule_type
      end)
    end
  end

  describe "evaluate with NotNilRule" do
    test "passes for non-nil values" do
      Enum.each([%{}, :a, MapSet.new()], fn value ->
        assert Brex.satisfies?(NotNilRule, value)
      end)
    end

    test "fails for nil" do
      refute Brex.satisfies?(NotNilRule, nil)
    end
  end

  test "evaluating an arbitrary atom raises UndefinedFunctionError" do
    assert_raise UndefinedFunctionError, fn ->
      Brex.Rule.Evaluable.evaluate(:an_arbitrary_atom, :anything)
    end
  end

  test "evaluating a module without evaluate/1 raises UndefinedFunctionError" do
    assert_raise UndefinedFunctionError, fn ->
      Brex.Rule.Evaluable.evaluate(InvalidRule, :anything)
    end
  end

  test "evaluating a raising rule propagates the error" do
    assert_raise RuntimeError, "Ain't nobody got time for that!", fn ->
      Brex.Rule.Evaluable.evaluate(RaisingRule, :anything)
    end
  end

  test "evaluating a throwing rule throws the value" do
    assert catch_throw(Brex.Rule.Evaluable.evaluate(ThrowingRule, :anything)) == :anything
  end
end
