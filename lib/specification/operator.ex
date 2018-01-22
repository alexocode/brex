defmodule Specification.Operator do
  @moduledoc """
  Operators to link links with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `none` no given rule has to be valid (`not`)
  """

  @type t :: {link(), clauses()}
  @type link :: :all | :any | :none
  @type clause :: Specifiation.Types.rule()
  @type clauses :: list(clause())

  @links [:all, :any, :none]

  @spec clauses(t(), link() | nil) :: clauses()
  def clauses(operator, expected_link \\ nil)

  @spec link(t(), link() | nil) :: link()
  def link(operator, expected_link \\ nil)

  for link <- @links do
    @spec unquote(link)() :: unquote(link)
    def unquote(link)(), do: unquote(link)

    @spec unquote(link)(clauses()) :: t()
    def unquote(link)(clauses) do
      {unquote(link), List.wrap(clauses)}
    end

    @spec unquote(link)(clause(), clause()) :: t()
    def unquote(link)(arg1, arg2) do
      unquote(link)([arg1, arg2])
    end
  end

  for link <- @links do
    def clauses({unquote(link), clauses}, nil), do: {:ok, clauses}
    def clauses({unquote(link), clauses}, unquote(link)), do: {:ok, clauses}
  end

  def clauses({actual, _clauses}, expected) when actual in @links and expected in @links do
    unexpected_operator(actual, expected)
  end

  def clauses(_operator, expected) when expected not in [nil | @links] do
    invalid_expected(expected)
  end

  def clauses(other, _expected) do
    invalid_operator(other)
  end

  def clauses!(operator, expected_operator \\ nil) do
    case clauses(operator, expected_operator) do
      {:ok, clauses} ->
        clauses

      {:error, reason} ->
        raise ArgumentError,
              "Can't extract operator clauses from `#{inspect(operator)}`" <>
                ", received error: #{inspect(reason)}"
    end
  end

  for link <- @links do
    def link({unquote(link), _clauses}, nil), do: {:ok, unquote(link)}
    def link({unquote(link), _clauses}, unquote(link)), do: {:ok, unquote(link)}
  end

  def link({actual, _clauses}, expected) when actual in @links and expected in @links do
    unexpected_operator(actual, expected)
  end

  def link(_operator, expected) when expected not in [nil | @links] do
    invalid_expected(expected)
  end

  def link(other, _expected) do
    invalid_operator(other)
  end

  def link!(operator, expected_operator \\ nil) do
    case link(operator, expected_operator) do
      {:ok, link} ->
        link

      {:error, reason} ->
        raise ArgumentError,
              "Can't extract operator link from `#{inspect(operator)}`" <>
                ", received error: #{inspect(reason)}"
    end
  end

  @spec operator?(t()) :: boolean()
  def operator?(operator), do: match?({:ok, _link}, link(operator))
  def operator?(operator, link), do: match?({:ok, ^link}, link(operator))

  defp unexpected_operator(actual, expected) do
    {:error, {:unexpected_operator, expected: expected, actual: actual}}
  end

  defp invalid_expected(expected_link) do
    {:error, {:invalid_expected_link, expected_link}}
  end

  defp invalid_operator(invalid) do
    {:error, {:invalid_operator, invalid}}
  end
end
