defmodule RulesEngineTest do
  use ExUnit.Case, async: true

  @graph "test/fixtures/order_tier.json" |> File.read!() |> Jason.decode!()

  test "evaluates a graph" do
    assert {:ok, %{"valid" => true, "tier" => "high"}} =
             RulesEngine.evaluate(@graph, %{"order" => %{"amount" => 120}})

    assert {:ok, %{"valid" => true, "tier" => "low"}} =
             RulesEngine.evaluate(@graph, %{"order" => %{"amount" => 5}})
  end

  test "a trace on request" do
    {:ok, result} = RulesEngine.evaluate(@graph, %{"order" => %{"amount" => 5}}, trace: true)
    assert is_map(result["trace"])

    {:ok, simulation} = RulesEngine.simulate(@graph, %{"order" => %{"amount" => 5}})
    assert %{"result" => %{"tier" => "low"}, "trace" => _, "performance" => _} = simulation
  end

  test "broken graphs are reported, not raised" do
    assert :ok = RulesEngine.validate(@graph)
    assert {:error, _} = RulesEngine.validate(%{"nodes" => [], "edges" => []})
    assert {:error, _} = RulesEngine.evaluate(%{"nodes" => "nope"}, %{})
  end
end
