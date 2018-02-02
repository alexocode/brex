defmodule Specification.Types do
  @moduledoc "Specifies types relevant to the Specification modules"

  @type evaluation :: Specification.Result.evaluation()
  @type result :: Specification.Result.t()
  @type rule :: Specification.Rule.t()
  @type value :: any()
end
