# defmodule Spex.Rule.ModuleSpec do
#   use ESpec, async: true

#   defmodule NotNilRule do
#     def evaluate(value) do
#       not is_nil(value)
#     end
#   end

#   it_behaves_like Shared.IsRuleSpec,
#     valid_rules: [
#       NotNilRule
#     ],
#     invalid_rules: [
#       :a,
#       1,
#       &is_list/1,
#       Spex.Operator.all([])
#     ]

#   it_behaves_like Shared.EvaluateSpec,
#     rule: NotNilRule,
#     valid_values: [
#       %{},
#       :a,
#       MapSet.new()
#     ],
#     invalid_values: [
#       nil
#     ]

#   defmodule RaisingRule do
#     def evaluate(_value) do
#       raise "Ain't nobody got time for that!"
#     end
#   end

#   it_behaves_like Shared.EvaluateSpec,
#     rule: RaisingRule,
#     valid_values: [],
#     invalid_values: [
#       1,
#       :"2",
#       "3",
#       %{4 => 5},
#       [6, 7]
#     ]

#   defmodule ThrowingRule do
#     def evaluate(value), do: throw(value)
#   end

#   it_behaves_like Shared.EvaluateSpec,
#     rule: ThrowingRule,
#     valid_values: [],
#     invalid_values: [
#       1,
#       :"2",
#       "3",
#       %{4 => 5},
#       [6, 7]
#     ]
# end
