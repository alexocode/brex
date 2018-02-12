defimpl Spex.Rule.Resultable, for: Any do
  def result(rule, value) do
    %Spex.Result{
      rule: rule,
      evaluation: Spex.Rule.evaluate(rule, value),
      value: value
    }
  end
end

defimpl Spex.Rule.Nestable, for: Any do
  def nested_rules(rule), do: List.wrap(rule)
end

defimpl Spex.Rule.Nestable, for: List do
  def nested_rules(rules) do
    Enum.flat_map(rules, &Spex.Rule.Nestable.nested_rules/1)
  end
end
