## Rules - Elixir NIF for BRE

[GoRules ZEN](https://github.com/gorules/zen) for Elixir: evaluates JDM graphs in-process through a Rust NIF.

+ NIF - Native Implemented Function
+ BRE - Business Rules Engine
+ JDM - JSON Decision Model

Graphs are the JSON that the [JDM Editor](https://github.com/gorules/jdm-editor) produces.

### Use

Add to `mix.exs` (a Rust toolchain is needed to compile):

```elixir
{:rules, github: "abitcipher/rules", tag: "v0.1.0"}
```

```elixir
graph = "rule.json" |> File.read!() |> Jason.decode!()

RulesEngine.validate(graph)
#=> :ok

RulesEngine.evaluate(graph, %{"order" => %{"amount" => 120}})
#=> {:ok, %{"tier" => "high", "valid" => true}}

RulesEngine.evaluate(graph, context, trace: true)
#=> {:ok, %{..., "trace" => %{...}}}

RulesEngine.simulate(graph, context)
#=> {:ok, %{"result" => _, "trace" => _, "performance" => _}}
```

Evaluation runs on a dirty CPU scheduler, so a long evaluation doesn't
block the BEAM's normal schedulers.

### Prebuilt library

Set `RULES_NIF_PREBUILT=1` at compile time to skip building the crate and
load `priv/native/librules.so` of the `:rules` application instead.

### Develop

```sh
mix deps.get
mix test
cargo fmt --check --manifest-path native/rules/Cargo.toml
cargo clippy --manifest-path native/rules/Cargo.toml -- -D warnings
```
