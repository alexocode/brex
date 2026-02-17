defmodule Brex.Rule.StructTest do
  use ExUnit.Case, async: true

  alias Support.Rules.EqualsRule

  describe "evaluate with EqualsRule{value: 42}" do
    @rule %EqualsRule{value: 42}

    test "passes for equal values" do
      Enum.each([42, 42.0], fn value ->
        assert Brex.satisfies?(@rule, value)
      end)
    end

    test "fails for unequal values" do
      Enum.each([1, 1337, :a, "foo"], fn value ->
        refute Brex.satisfies?(@rule, value)
      end)
    end
  end

  test "raises CompileError for struct without evaluate/2" do
    assert_raise CompileError, ~r/cannot use Brex.Rule.Struct/, fn ->
      defmodule NoEvaluateFunctionStruct do
        use Brex.Rule.Struct

        defstruct []
      end
    end
  end

  test "raises CompileError for non-struct module" do
    assert_raise CompileError, fn ->
      defmodule NoStructModule do
        use Brex.Rule.Struct

        def evaluate(_, _), do: :ok
      end
    end
  end
end
