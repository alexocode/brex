defmodule Specification.Types do
  @moduledoc false

  @type rules :: list(rule())
  @type rule :: (value() -> result_value()) | Specification.Rule.t() | operator()

  @type operator :: Specification.Operator.t()

  @type result_value :: boolean() | :ok | {:ok, any()} | {:error, any()}
  @type result :: {rule(), result_value()}
  @type results :: list(result())

  @type value :: any()
end
