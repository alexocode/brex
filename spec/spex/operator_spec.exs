defmodule Spex.OperatorSpec do
  use ESpec, async: true

  doctest Spex.Operator

  describe ".new" do
    subject do: described_module().new(operator(), rules())

    for operator <- Spex.Operator.default_operators() do
      context "for #{operator}" do
        let operator: unquote(operator)
        let rules: [1, 2, 3]

        it "returns a #{operator} struct" do
          should(be_struct unquote(operator))
        end
      end
    end
  end

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
