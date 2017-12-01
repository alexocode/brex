defmodule SpecificationTest do
  use ExUnit.Case
  doctest Specification

  test "greets the world" do
    assert Specification.hello() == :world
  end
end
