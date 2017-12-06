defmodule Specification.EvaluatorTest do
  use ExUnit.Case

  import Specification.Evaluator

  doctest Specification.Evaluator

  describe ".evaluate(<raising-function>, <any>)" do
    test "should return an error tuple with the raised error" do
      rule = &raise(inspect(&1))
      value = :whatever
      expected_error = {:error, %RuntimeError{message: inspect(value)}}

      assert {^rule, ^expected_error} = evaluate(rule, value)
    end

    test "should return an error tuple with the thrown thing" do
      rule = &throw(&1)
      value = :whatever
      expected_error = {:error, value}

      assert {^rule, ^expected_error} = evaluate(rule, value)
    end
  end
end
