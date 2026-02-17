defmodule Brex.Trace do
  @moduledoc """
  Converts a `Brex.Result` evaluation tree into a `Tracer.t()` for visual
  inspection.

  Each result becomes a node in the trace tree:

  - `step` — the rule identity:
    * operators → `:all`, `:any`, `:none` (or the aggregator's function name)
    * named functions → `{module, name, arity}` MFA tuple
    * anonymous functions → `:anonymous_fn`
    * struct-based rules → the struct module
    * module-based rules → the module atom
  - `input` — the evaluated value
  - `output` — `{:ok, :passed}` / `{:error, :failed}` for operators; raw
    evaluation (`true`, `false`, `:ok`, `{:error, reason}`, etc.) for leaf rules
  - `nested` — child traces for operator rules; `[]` for leaf rules

  Use `inspect/2` on the returned `Tracer.t()` to render a color-coded tree.
  See `Tracer` inspect options (`depth`, `indent`) for controlling output depth.

  ## Examples

      iex> result = Brex.evaluate(&is_list/1, [1, 2])
      iex> trace = Brex.Trace.from_result(result)
      iex> trace.step
      {:erlang, :is_list, 1}
      iex> trace.input
      [1, 2]
      iex> trace.output
      true

      iex> result = Brex.evaluate(&is_list/1, "not a list")
      iex> Brex.Trace.from_result(result) |> Tracer.error?()
      true

      iex> result = Brex.evaluate(Brex.all([&is_list/1, &Keyword.keyword?/1]), [a: 1])
      iex> trace = Brex.Trace.from_result(result)
      iex> trace.step
      :all
      iex> trace.output
      {:ok, :passed}
      iex> length(trace.nested)
      2

      iex> result = Brex.evaluate(Brex.any([&is_list/1, &is_map/1]), "hello")
      iex> trace = Brex.Trace.from_result(result)
      iex> trace.output
      {:error, :failed}
      iex> length(trace.nested)
      2

      iex> result = Brex.evaluate(Brex.none([&is_list/1, &is_map/1]), "hello")
      iex> trace = Brex.Trace.from_result(result)
      iex> trace.step
      :none
      iex> Tracer.ok?(trace)
      true

      iex> double = fn x -> x * 2 end
      iex> result = Brex.evaluate(double, 3)
      iex> Brex.Trace.from_result(result).step
      :anonymous_fn
  """

  @spec from_result(Brex.Result.t()) :: Tracer.t()
  def from_result(%Brex.Result{rule: %Brex.Operator{} = rule, value: value, evaluation: evaluation}) do
    {output, nested} =
      case evaluation do
        {:ok, results} -> {{:ok, :passed}, Enum.map(results, &from_result/1)}
        {:error, results} -> {{:error, :failed}, Enum.map(results, &from_result/1)}
      end

    Tracer.new(step(rule), value, output, nested)
  end

  def from_result(%Brex.Result{rule: rule, value: value, evaluation: evaluation}) do
    Tracer.new(step(rule), value, evaluation, [])
  end

  defp step(%Brex.Operator{aggregator: agg}) do
    case Function.info(agg, :name) do
      {:name, :all?} -> :all
      {:name, :any?} -> :any
      {:name, :none?} -> :none
      {:name, name} -> name
    end
  end

  defp step(fun) when is_function(fun) do
    info = Function.info(fun)

    case info[:type] do
      :external -> {info[:module], info[:name], info[:arity]}
      :local -> :anonymous_fn
    end
  end

  defp step(struct) when is_struct(struct), do: struct.__struct__
  defp step(other), do: other
end
