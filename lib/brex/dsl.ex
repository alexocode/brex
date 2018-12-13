defmodule Brex.DSL do
  import Brex.DSL.Operators, only: [is_operator: 1]

  alias Brex.DSL.{Clean, Operators}

  defmacro rule(rules \\ [], do: block) do
    quote do: unquote(process_ast(block, rules) |> Macro.escape())
  end

  def process_ast(ast, rules \\ []) do
    ast
    |> IO.inspect(label: "RAW")
    |> Clean.process_ast()
    |> IO.inspect(label: "CLEANED")
    |> build(rules)
    |> IO.inspect(label: "BUILT")
  end

  defp build(operator, rules) when is_operator(operator) do
    operator
    |> Operators.process_ast()
    |> build(rules)
  end

  defp build({operator, clauses}, rules) when operator in [:all, :any, :none] do
    clauses =
      clauses
      |> build(rules)
      |> List.flatten()

    apply(Brex, operator, [clauses])
  end

  defp build(list, rules) when is_list(list) do
    Enum.map(list, &build(&1, rules))
  end

  defp build({function, context, value}, rules) do
    value = build(value, rules)

    case Keyword.get(rules, function) do
      nil -> {function, context, value}
      rule -> rule.build(value)
    end
  end

  defp build(other, _rules), do: other
end
