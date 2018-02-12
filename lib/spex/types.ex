defmodule Spex.Types do
  @moduledoc "Specifies types relevant to the Spex modules"

  @type evaluation :: Spex.Result.evaluation()
  @type result :: Spex.Result.t()
  @type rule :: Spex.Rule.t()
  @type value :: any()
end
