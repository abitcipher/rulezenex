## Rulezenex - Elixir NIF for BRE

[GoRules ZEN](https://github.com/gorules/zen) for Elixir: evaluates JDM graphs in-process through a Rust NIF.

+ NIF - Native Implemented Function
+ BRE - Business Rules Engine
+ JDM - JSON Decision Model

Graphs are the JSON that the [JDM Editor](https://github.com/gorules/jdm-editor) produces.

### Use

Add to `mix.exs` (a Rust toolchain is needed to compile):

```elixir
{:rulezenex, "~> 0.1.1"}
```

```elixir
graph = "rule.json" |> File.read!() |> Jason.decode!()

RulezenexEngine.validate(graph)
#=> :ok

RulezenexEngine.evaluate(graph, %{"order" => %{"amount" => 120}})
#=> {:ok, %{"tier" => "high", "valid" => true}}

RulezenexEngine.evaluate(graph, context, trace: true)
#=> {:ok, %{..., "trace" => %{...}}}

RulezenexEngine.simulate(graph, context)
#=> {:ok, %{"result" => _, "trace" => _, "performance" => _}}
```

Evaluation runs on a dirty CPU scheduler, so a long evaluation doesn't
block the BEAM's normal schedulers.

### Prebuilt library

Set `RULEZENEX_NIF_PREBUILT=1` at compile time to skip building the crate and
load `priv/native/librulezenex.so` of the `:rulezenex` application instead.

### Develop

```sh
mix deps.get
mix test
cargo fmt --check --manifest-path native/rulezenex/Cargo.toml
cargo clippy --manifest-path native/rulezenex/Cargo.toml -- -D warnings
```

### License

[MIT](LICENSE). GoRules ZEN is MIT licensed by GoRules.
