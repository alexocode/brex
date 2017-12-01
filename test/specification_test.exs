defmodule SpecificationTest do
  use ExUnit.Case

  import Specification

  doctest Specification

  describe ".satisfies?(\"\", <specifications>)" do
    # Positive

    test "should satisfy with an empty specification set" do
      assert satisfies?("", []) == true
    end

    test "should satisfy with a function returning true" do
      assert satisfies?("", fn _ -> true end) == true
    end

    test "should satisfy with multiple functions returning true" do
      rules = [
        fn _ -> true end,
        fn _ -> true end,
        fn _ -> true end,
        fn _ -> true end
      ]

      assert satisfies?("", rules) == true
    end

    test "should satisfy with a function returning an ok result" do
      assert satisfies?("", &{:ok, &1}) == true
    end

    # Negative

    test "should not satisfy with a function returning false" do
      assert satisfies?("", fn _ -> false end) == false
    end

    test "should not satisfy with a function returning true and one returning false" do
      rules = [
        fn _ -> false end,
        fn _ -> true end
      ]

      assert satisfies?("", rules) == false
    end

    test "should not satisfy with a function returning an error result" do
      assert satisfies?("", &{:error, &1}) == false
    end
  end
end
