defimpl Spex.Rule.Module, for: Atom do
  def evaluate(module, value) when function_exported?(module, :evaluate, 1) do
    module.evaluate(value)
  end

  def evaluate(atom, _value) do
    raise ArgumentError, "#{inspect(atom)} is no module or does not export evaluate/1"
  end
end
