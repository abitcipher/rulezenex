defmodule RulesEngine do
  @moduledoc """
  GoRules ZEN evaluating JSON Decision Model (JDM) graphs in-process.

  A graph is the map the JDM Editor produces; a context is any map.

      iex> RulesEngine.evaluate(graph, %{"amount" => 120})
      {:ok, %{"tier" => "high"}}

  Set `RULES_NIF_PREBUILT=1` at compile time to load a library built
  elsewhere (`priv/native/librules.so` of this application) instead of
  compiling the crate.
  """
  use Rustler,
    otp_app: :rules,
    crate: "rules",
    mode: :release,
    skip_compilation?: System.get_env("RULES_NIF_PREBUILT") == "1"

  @doc """
  Evaluates `graph` with `context`. Returns `{:ok, result}` with the output
  node's value, or `{:error, reason}`. With `trace: true` the result also
  holds the evaluation trace under `"trace"`.
  """
  @spec evaluate(map(), map(), keyword()) :: {:ok, map()} | {:error, term()}
  def evaluate(graph, context, opts \\ []) do
    trace? = Keyword.get(opts, :trace, false)

    case nif_evaluate(Jason.encode!(graph), Jason.encode!(context), trace?) do
      {:ok, json} ->
        response = Jason.decode!(json)
        result = response["result"] || %{}
        {:ok, if(trace?, do: Map.put(result, "trace", response["trace"]), else: result)}

      {:error, json} ->
        {:error, decode_error(json)}
    end
  end

  @doc """
  A traced evaluation. Returns `{:ok, %{"result" => _, "trace" => _,
  "performance" => _}}` or `{:error, reason}`.
  """
  @spec simulate(map(), map()) :: {:ok, map()} | {:error, term()}
  def simulate(graph, context) do
    case nif_evaluate(Jason.encode!(graph), Jason.encode!(context), true) do
      {:ok, json} -> {:ok, Jason.decode!(json)}
      {:error, json} -> {:error, decode_error(json)}
    end
  end

  @doc "Checks that `graph` is a well-formed decision graph."
  @spec validate(map()) :: :ok | {:error, String.t()}
  def validate(graph) do
    case nif_validate(Jason.encode!(graph)) do
      {:ok, _} -> :ok
      {:error, message} -> {:error, message}
    end
  end

  defp decode_error(json) do
    case Jason.decode(json) do
      {:ok, map} -> map
      _ -> json
    end
  end

  defp nif_evaluate(_graph, _context, _trace), do: :erlang.nif_error(:nif_not_loaded)
  defp nif_validate(_graph), do: :erlang.nif_error(:nif_not_loaded)
end
