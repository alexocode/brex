defmodule Specification do
  @moduledoc """
  Documentation for Specification.
  """

  def satisfies?(_value, []), do: true

  def satisfies?(value, rule) when is_function(rule, 1) do
    case rule.(value) do
      boolean when is_boolean(boolean) ->
        boolean

      # OK Result
      :ok ->
        true

      {:ok, _} ->
        true

      # Error result
      {:error, _} ->
        false
    end
  end

  def satisfies?(value, rules) when is_list(rules) do
    Enum.all?(rules, &satisfies?(value, &1))
  end

  def satisfies?(value, rule) when is_tuple(rule) do
    case rule do
      {:or, left, right} ->
        satisfies?(value, left) or satisfies?(value, right)

      {:not, negate} ->
        not satisfies?(value, negate)
    end
  end
end
