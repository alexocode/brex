defmodule Brex.Operator.Defaults do
  @moduledoc false

  def all(rules) do
    %Brex.Operator{
      aggregator: &Brex.Operator.Aggregator.all?/1,
      clauses: rules
    }
  end

  def any(rules) do
    %Brex.Operator{
      aggregator: &Brex.Operator.Aggregator.any?/1,
      clauses: rules
    }
  end

  def none(rules) do
    %Brex.Operator{
      aggregator: &Brex.Operator.Aggregator.none?/1,
      clauses: rules
    }
  end
end
