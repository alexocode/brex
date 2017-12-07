defmodule Specification.Types do
  @moduledoc "Specifies types relevant to the Specification modules"

  @type rules :: list(rule())
  @type rule :: rule_fn() | Specification.Rule.t() | operator()
  @type rule_fn :: (value() -> result_value())

  @type operator :: Specification.Operator.t()

  @type result_value :: boolean() | :ok | {:ok, any()} | {:error, any()}
  @type result :: {rule(), result_value()}
  @type results :: list(result())

  @type value :: any()
end
