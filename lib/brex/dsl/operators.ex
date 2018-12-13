defmodule Brex.DSL.Operators do
  @moduledoc false

  @brex_operator_mapping %{
    and: :all,
    or: :any,
    not: :none
  }

  @operators Map.keys(@brex_operator_mapping)

  defmacro is_operator(operator) do
    quote do
      is_tuple(unquote(operator)) and tuple_size(unquote(operator)) in [2, 3] and
        elem(unquote(operator), 0) in unquote(@operators)
    end
  end

  def process_ast(operator), do: process(operator)

  defp process({operator, _context, args}) when operator in @operators do
    process({operator, args})
  end

  defp process({operator, value}) when operator in @operators do
    value = collapse(operator, value)
    brex_operator = @brex_operator_mapping[operator]

    process({brex_operator, [value]})
  end

  defp process(value), do: value

  defp collapse(operator, list) when is_list(list),
    do: Enum.flat_map(list, &collapse(operator, &1))

  defp collapse(operator, {operator, _, value}), do: collapse(operator, value)
  defp collapse(_operator, value), do: List.wrap(value)
end
