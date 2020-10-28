defmodule Brex.Result.Formatter do
  @moduledoc """
  A behaviour specifying a `format/1` callback which takes a list of results and
  reduces them to whatever the formatter wants to.

  When "used" the module provides `format/1` definitions which handle a list of
  `Brex.Result` structs and map them again to `format/1`. This definitions have
  the lowest precedence and can be overridden as you see fit.

  The last `format/1` definition matches on anything and calls the imported
  `invalid_result!/1` function which raises an `ArgumentError` with an
  informative message.

  ## Default Formatters

  - `Brex.Result.Formatter.Rules`
  """

  @callback format(list(Brex.Types.result())) :: any()

  defmacro __using__(_which) do
    quote location: :keep do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      alias Brex.Result

      import unquote(__MODULE__), only: [invalid_result!: 1]
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def format([]), do: []

      def format([%Brex.Result{} | _] = results) do
        Enum.map(results, &format/1)
      end

      def format(unknown_result) do
        invalid_result!(unknown_result)
      end
    end
  end

  @doc """
  Raises an `ArgumentError` which informs the caller that the provided value was
  __not__ a valid `Brex.Rule` struct.
  """
  def invalid_result!(result) do
    raise ArgumentError,
          "Invalid result! Expected a list of or single `Brex.Result` struct but received: #{
            inspect(result)
          }"
  end
end
