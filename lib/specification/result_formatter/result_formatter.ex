defmodule Specification.ResultFormatter do
  @moduledoc """
  A behaviour specifying a `format/1` callback which takes a list of results and
  reduces them to whatever the formatter wants to.

  When "used" the module provides a `format/1` clause which takes a single
  result, ensures that it's a two value tuple and wraps it in a list.

  Furthermore it provides a `invalid_result!` function which raises an
  `ArgumentError` with an informative error message.

  These are the default formatters:
  - `Specification.ResultFormatter.Boolean`
  """

  @callback format(Specification.Types.results()) :: any()

  defmacro __using__(_which) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)

      import unquote(__MODULE__)

      def format({_rule, _result} = single_result) when not is_list(single_result) do
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
          "Invalid evaluation result! Expects a list of two value tuples like `{MyCustomRule, true}`. " <>
            "Instead received: #{inspect(result)}"
  end
end
