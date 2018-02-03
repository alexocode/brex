defimpl Specification.Rule.Result, for: Any do
  def result(rule, value) do
    %Specification.Result{
      rule: rule.
      evaluation: Specification.Rule.evaluate(rule, value),
      value: value
    }
  end
end

defimpl Specification.Rule.NumberOfClauses, for: Any do
  def number_of_clauses(_), do: 1
end
