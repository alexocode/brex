# Brex
[![CI](https://github.com/sascha-wolf/brex/workflows/CI/badge.svg)](https://github.com/sascha-wolf/brex/actions?query=workflow%3ACI+branch%3Amain)
[![Coverage Status](https://coveralls.io/repos/github/sascha-wolf/brex/badge.svg?branch=master)](https://coveralls.io/github/sascha-wolf/brex?branch=master)
[![Hexdocs.pm](https://img.shields.io/badge/hexdocs-online-blue)](https://hexdocs.pm/brex/)
[![Hex.pm](https://img.shields.io/hexpm/v/brex.svg)](https://hex.pm/packages/brex)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/brex)](https://hex.pm/packages/brex)

*A [Specification Pattern](https://en.wikipedia.org/wiki/Specification_pattern) implementation in Elixir.*

Using `brex` you can easily

- __define__
- __compose__ and
- __evaluate__

**b**usiness **r**ules to dynamically drive the flow of your application.

## Motiviation

`Brex` was built to allow you to define and compose rules to evaluate them later. This enables you to build your rules from some kind of configuration, be it a database, a CSV or JSON or anything else.

Maybe you want to allow your customer to create dynamic rules for sending out emails or push notifications? Or you want to decide on the type of event to trigger based on incoming data? Or you think bigger and want to create some kind of flow chart interface?

Whatever your particular use-case, `Brex` has you covered when it comes to composition of rules.

## Basics

The lowest building stone of `Brex` is a __rule__. A rule can have many shapes, for example this is a rule:

```elixir
&is_list/1
```

This is a rule too:

```elixir
Brex.all([&is_list/1, &(length(&1) > 0)])
```

Or this:

```elixir
defmodule MyRule do
  @behaviour Brex.Rule

  @impl true
  def evaluate(:foo), do: true
  def evaluate(:bar), do: false
end
```

Also this:

```elixir
defmodule MyStruct do
  use Brex.Rule.Struct

  defstruct [:foo]

  def evaluate(%{foo: foo}, value) do
    foo == value
  end
end
```

### Enough talk about defining rules, how can I _evaluate_ them?

Well great that you ask, that's simple too!

```elixir
iex> Brex.satisfies? MyRule, :foo
true
```

As you can see, `Brex` is flexible and easy to use. All of this is based on the [`Brex.Rule.Evaluable`][evaluable] protocol, if you're really interested, take a look at [`Brex.Rule`][rule] which talks about the possible rule types a little bit more.

# Operators

Also, as you might have noticed, I used an `all/1` function in the examples
above. This is the __compose__ part of `Brex`: it allows you to link rules
using boolean logic.

It currently supports:

- `all`
- `any`
- `none`

I think the names speak for themself.

You can define your own operators, if you're interested then take a look at the [`Brex.Operator`][operator] module.

## Installation

Simply add `brex` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:brex, "~> 0.1.0"}
  ]
end
```

# Configuration

Right now, there is no need for any kind of configuration in `Brex`. In case you see some need for it, please open an issue.

[evaluable]: https://github.com/sascha-wolf/brex/blob/master/lib/brex/rule.ex#L9-L20
[operator]: https://github.com/sascha-wolf/brex/blob/master/lib/brex/operator.ex
[rule]: https://github.com/sascha-wolf/brex/blob/master/lib/brex/rule.ex
