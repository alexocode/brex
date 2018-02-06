defimpl Specification.Rule.Resultable, for: Any do
  def result(rule, value) do
    %Specification.Result{
      rule: rule,
      evaluation: Specification.Rule.evaluate(rule, value),
      value: value
    }
  end
end

defimpl Specification.Rule.Nestable, for: Any do
  def nested_rules(rule), do: List.wrap(rule)
end

defimpl Specification.Rule.Nestable, for: List do
  def nested_rules(rules) do
    Enum.flat_map(rules, &Specification.Rule.Nestable.nested_rules/1)
  end
end
