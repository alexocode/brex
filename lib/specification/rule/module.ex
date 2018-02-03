defimpl Specification.Rule, for: Atom do
  def evaluate(module, value) when function_exported?(module, :evaluate, 1) do
    module.evaluate(value)
  catch
    error -> {:error, error}
  rescue
    error -> {:error, error}
  end
end
