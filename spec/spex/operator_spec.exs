defmodule Spex.OperatorSpec do
  use ESpec, async: true

  doctest Spex.Operator

  describe ".clauses!" do
    subject do: described_module().clauses!(operator())

    for op <- [&is_list/1, :foo, "bar"] do
      context "for an invalid operator `#{inspect(op)}`" do
        let operator: unquote(op)

        it do: expect((&subject/0) |> to(raise_exception Protocol.UndefinedError))
      end
    end
  end
end
