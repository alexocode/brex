defimpl Spex.Rule.Evaluable, for: Function do
  def evaluate(rule, value) do
    rule.(value)
  end
end
