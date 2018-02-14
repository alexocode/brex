# defmodule Spex.OperatorSpec do
#   use ESpec, async: true

#   links = [:all, :any, :none]

#   defp operator(link, clauses) do
#     apply(described_module(), link, [clauses])
#   end

#   let rules: [:just, :some, :rules]

#   for link <- links do
#     slink = Atom.to_string(link)
#     ilink = inspect(link)

#     describe ".#{slink} <rules>" do
#       subject do: operator(unquote(link), rules())

#       let link: unquote(link)

#       it "should wrap the given rules into a tuple" do
#         should(be_tuple())

#         subject()
#         |> Tuple.to_list()
#         |> should(have_count 2)
#       end

#       it "should contain `#{ilink}` as first tuple element" do
#         subject()
#         |> elem(0)
#         |> should(eq unquote(link))
#       end

#       it "should contain the rules as second tuple element" do
#         subject()
#         |> elem(1)
#         |> should(eq rules())
#       end
#     end
#   end

#   describe ".link " do
#     subject do: described_module().link(operator(), limit())

#     for link <- links do
#       slink = Atom.to_string(link)

#       context "for an invalid operator" do
#         let operator: {:foo_bar, rules()}

#         context "with no limit" do
#           let limit: nil

#           it "should return an invalid operator error" do
#             should(eq {:error, {:invalid_operator, operator()}})
#           end
#         end

#         context "with `:any` limit" do
#           let limit: :any

#           it "should return an invalid operator error" do
#             should(eq {:error, {:invalid_operator, operator()}})
#           end
#         end
#       end

#       context "for #{slink}" do
#         let operator: operator(unquote(link), rules())

#         context "limiting it to nothing" do
#           let limit: nil

#           it "should return an ok result with the link" do
#             should(eq {:ok, unquote(link)})
#           end
#         end

#         context "limiting it to #{slink}" do
#           let limit: unquote(link)

#           it "should return an ok result with the link" do
#             should(eq {:ok, unquote(link)})
#           end
#         end

#         context "limiting it to `:garbage`" do
#           let limit: :garbage

#           it "should return an invalid expected link error" do
#             should(eq {:error, {:invalid_expected_link, :garbage}})
#           end
#         end

#         index = Enum.find_index(links, &(&1 == link))
#         other = Enum.at(links, index - 1)
#         iother = inspect(other)

#         context "limiting it to `#{iother}`" do
#           let limit: unquote(other)

#           it "should return an unexpected operator error" do
#             error =
#               {:error, {:unexpected_operator, expected: unquote(other), actual: unquote(link)}}

#             should(eq error)
#           end
#         end
#       end
#     end
#   end

#   describe ".clauses " do
#     subject do: described_module().clauses(operator(), limit())

#     for link <- links do
#       slink = Atom.to_string(link)

#       context "for an invalid operator" do
#         let operator: {:foo_bar, rules()}

#         context "with no limit" do
#           let limit: nil

#           it "should return an invalid operator error" do
#             should(eq {:error, {:invalid_operator, operator()}})
#           end
#         end

#         context "with `:any` limit" do
#           let limit: :any

#           it "should return an invalid operator error" do
#             should(eq {:error, {:invalid_operator, operator()}})
#           end
#         end
#       end

#       context "for #{slink}" do
#         let operator: operator(unquote(link), rules())

#         context "limiting it to nothing" do
#           let limit: nil

#           it "should return an ok result with the rules" do
#             should(eq {:ok, rules()})
#           end
#         end

#         context "limiting it to #{slink}" do
#           let limit: unquote(link)

#           it "should return an ok result with the rules" do
#             should(eq {:ok, rules()})
#           end
#         end

#         context "limiting it to `:garbage`" do
#           let limit: :garbage

#           it "should return an invalid expected link error" do
#             should(eq {:error, {:invalid_expected_link, :garbage}})
#           end
#         end

#         index = Enum.find_index(links, &(&1 == link))
#         other = Enum.at(links, index - 1)
#         iother = inspect(other)

#         context "limiting it to `#{iother}`" do
#           let limit: unquote(other)

#           it "should return an unexpected operator error" do
#             error =
#               {:error, {:unexpected_operator, expected: unquote(other), actual: unquote(link)}}

#             should(eq error)
#           end
#         end
#       end
#     end
#   end
# end
