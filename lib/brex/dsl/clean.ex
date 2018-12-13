defmodule Brex.DSL.Clean do
  @moduledoc false

  def process_ast(ast) do
    unwrap_block(ast)
  end

  defp unwrap_block({:__block__, _context, block}), do: block
  defp unwrap_block(other), do: other
end
