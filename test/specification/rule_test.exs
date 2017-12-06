defmodule Specification.RuleTest do
  use ExUnit.Case

  alias Specification.Rule

  describe "a simple rule" do
    defmodule SimpleRule do
      @behaviour Specification.Rule

      @impl true
      def evaluate(_value), do: true
    end

    test "should return true" do
      assert true == Rule.call_evaluate(SimpleRule, :foo)
    end
  end

  describe "a module not being a rule" do
    defmodule NoRule do
    end

    test "should raise an ArgumentError" do
      call_evaluate_fn = fn -> Rule.call_evaluate(NoRule, :whatever) end

      assert_raise ArgumentError, "Invalid rule: #{inspect(NoRule)}", call_evaluate_fn
    end
  end

  describe "a module raising an error" do
    defmodule RaisingRule do
      @behaviour Specification.Rule

      @impl true
      def evaluate(_value) do
        raise "Ain't nobody got time for that!"
      end
    end

    test "should return an error tuple containing the raised error" do
      result = Rule.call_evaluate(RaisingRule, 42)
      expected = {:error, %RuntimeError{message: "Ain't nobody got time for that!"}}

      assert expected == result
    end
  end

  describe "a module throwing the value" do
    defmodule ThrowingRule do
      @behaviour Specification.Rule

      @impl true
      def evaluate(value), do: throw(value)
    end

    test "should return an error tuple containing the thrown value" do
      value = 42

      result = Rule.call_evaluate(ThrowingRule, value)
      expected = {:error, value}

      assert expected == result
    end
  end
end
