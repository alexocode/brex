defmodule Spex.Result.Formatter do
  @moduledoc """
  A behaviour specifying a `format/1` callback which takes a list of results and
  reduces them to whatever the formatter wants to.

  When "used" the module provides a `format/1` clause which takes a single
  result, ensures that it's a two value tuple and wraps it in a list.

  Furthermore it provides a `invalid_result!` function which raises an
  `ArgumentError` with an informative error message.

  These are the default formatters:
  - `Spex.Result.Formatter.Boolean`
  """

  @callback format(list(Spex.Types.result())) :: any()

  defmacro __using__(_which) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)

      alias Spex.Result

      import unquote(__MODULE__)

      def format(%Result{} = single_result) do
        single_result
        |> List.wrap()
        |> format()
      end

      def format(unknown_result) when not is_list(unknown_result) do
        invalid_result!(unknown_result)
      end
    end
  end

  def invalid_result!(result) do
    raise ArgumentError,
          "Invalid evaluation result! Expects a `Spex.Result` struct. " <>
            "Instead received: #{inspect(result)}"
  end
end
