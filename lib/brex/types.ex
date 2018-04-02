defmodule Brex.Types do
  @moduledoc "Specifies types relevant to the Brex modules"

  @type evaluation :: Brex.Result.evaluation()
  @type result :: Brex.Result.t()
  @type rule :: Brex.Rule.t()
  @type value :: any()
end
