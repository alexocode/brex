# Spex
[![Build Status](https://travis-ci.org/Zeeker/spex.svg?branch=master)](https://travis-ci.org/Zeeker/spex)
[![Coverage Status](https://coveralls.io/repos/github/Zeeker/spex/badge.svg?branch=master)](https://coveralls.io/github/Zeeker/spex?branch=master)

*A [Specification Pattern](https://en.wikipedia.org/wiki/Specification_pattern) implementation in Elixir.*

Using `spex` you can easily

- __define__
- __compose__ and
- __evaluate__

rules at __runtime__.

## Motiviation

`Spex` was built to allow you to evaluate data based on business rules which change over time and need to be configured in one fashion or another.

Maybe you want to allow your customer to create dynamic rules for sending out emails or push notifications? Or you want to decide on the type of event to trigger based on imcoming data? Or you think bigger and want to create some kind of flow chart interface?

Whatever your use-case, `Spex` has you covered.

## Basics

The lowest building stone of `Spex` is a __rule__. A rule can
have many shapes, for example this is a rule:

```elixir
&is_list/1
```

This is a rule too:

```elixir
Spex.all([&is_list/1, &(length(&1) > 0)])
```

Or this:

```elixir
defmodule MyRule do
  def evaluate(:foo), do: true
  def evaluate(:bar), do: false
end
```

Also this:

```elixir
defmodule MyStruct do
  use Spex.Rule.Struct

  defstruct [:foo]

  def evaluate(%{foo: foo}, value) do
    foo == value
  end
end
```

### *Enough talk about defining rules, how can I __evaluate__ them?*

Well great that you ask, that's simple too!

```elixir
iex> Spex.satisfies? MyRule, :foo
true
```

As you can see, `Spex` is flexible and easy to use. All of this is based on
the `Spex.Rule.Evaluable` protocol, if you're really interested, take a look
at `Spex.Rule` which talks about the possible rule types a little bit more.

# Operators

Also, as you might have noticed, I used an `all/1` function in the examples
above. This is the __compose__ part of `Spex`: it allows you to link rules
using boolean logic.

It currently supports:

- `all/1`
- `any/1`
- `none/1`

I think the names speak for themself.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/spex](https://hexdocs.pm/spex).
