defmodule Brex.Result.Success do
  module = inspect(__MODULE__)

  @moduledoc """
  A rule which checks if the given value is a "success" value, these include:
  - `:ok`
  - `{:ok, _}`
  - `true`

  ## Examples

      iex> #{module}.evaluate(:ok)
      true

      iex> #{module}.evaluate({:ok, :some_value})
      true

      iex> #{module}.evaluate(true)
      true

      iex> #{module}.evaluate(false)
      false

      iex> #{module}.evaluate("some random stuff")
      false
  """

  @behaviour Brex.Rule

  @impl Brex.Rule
  def evaluate(true), do: true
  def evaluate(:ok), do: true
  def evaluate({:ok, _}), do: true
  def evaluate(_), do: false
end
