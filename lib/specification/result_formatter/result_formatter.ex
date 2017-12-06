defmodule Specification.ResultFormatter do
  @moduledoc false

  @callback format(Specification.Types.results()) :: any()

  defmacro __using__(_which) do
    quote do
      @behaviour unquote(__MODULE__)

      def format(single_result) when not is_list(single_result) do
        single_result
        |> List.wrap()
        |> format()
      end
    end
  end
end
