defimpl Brex.Rule.Evaluable, for: Atom do
  def evaluate(module, value) do
    module.evaluate(value)
  end
end
