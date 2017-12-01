defmodule Specification.Rule do
  @moduledoc false

  def unquote(:and)(left, right), do: [left, right]
  def unquote(:or)(left, right), do: {:or, left, right}
  def unquote(:not)(negate), do: {:not, negate}
end
