defmodule Brex.Rules.Failure do
  module = inspect(__MODULE__)

  @moduledoc """
  A rule which checks if the given value is a "failure" value, these include:
  - `:error`
  - `{:error, _}`
  - `false`

  ## Examples

      iex> #{module}.evaluate(:error)
      true

      iex> #{module}.evaluate({:error, :some_value})
      true

      iex> #{module}.evaluate(false)
      true

      iex> #{module}.evaluate(true)
      false

      iex> #{module}.evaluate("some random stuff")
      false
  """

  @behaviour Brex.Rule

  @impl Brex.Rule
  def evaluate(false), do: true
  def evaluate(:error), do: true
  def evaluate({:error, _}), do: true
  def evaluate(_), do: false
end
