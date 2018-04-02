defimpl Brex.Rule.Evaluable, for: Function do
  def evaluate(rule, value) do
    rule.(value)
  rescue
    error -> {:error, error}
  end
end
