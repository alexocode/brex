defmodule SpecificationTest do
  use ExUnit.Case

  alias Specification.Rule

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

  describe ".satisfies?(:foo, <specifications-linked-with-and>)" do
    test "should satisfy with two functions returning true" do
      specs = Rule.and(fn _ -> true end, fn _ -> true end)

      assert satisfies?(:foo, specs) == true
    end

    test "should not satisfy with two functions returning false" do
      specs = Rule.and(fn _ -> false end, fn _ -> false end)

      assert satisfies?(:foo, specs) == false
    end

    test "should not satisfy with one function returning false and one returning true" do
      specs = Rule.and(fn _ -> false end, fn _ -> true end)

      assert satisfies?(:foo, specs) == false
    end
  end

  describe ".satisfies?(:foo, <specifications-linked-with-or>)" do
    test "should satisfy with two functions returning true" do
      specs = Rule.or(fn _ -> true end, fn _ -> true end)

      assert satisfies?(:foo, specs) == true
    end

    test "should not satisfy with two functions returning false" do
      specs = Rule.or(fn _ -> false end, fn _ -> false end)

      assert satisfies?(:foo, specs) == false
    end

    test "should satisfy with one function returning false and one returning true" do
      specs = Rule.or(fn _ -> false end, fn _ -> true end)

      assert satisfies?(:foo, specs) == true
    end
  end

  describe ".satisfies?(:foo, <specification-wrapped-in-not>)" do
    test "should satisfy with a function returning false" do
      specs = Rule.not(fn _ -> false end)

      assert satisfies?(:foo, specs) == true
    end

    test "should not satisfy with a function returning true" do
      specs = Rule.not(fn _ -> true end)

      assert satisfies?(:foo, specs) == false
    end
  end
end
