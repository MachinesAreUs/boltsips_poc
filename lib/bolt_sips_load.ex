defmodule BoltSipsLoad do
  @moduledoc """
  Documentation for CypherProfiler.
  """
  require Logger

  @queries [
    drivers: {
      """
      MATCH (n:Driver) RETURN {id: n.id, name: n.name, phone: n.phone, email: n.email} as drivers
      """
    }
  ]

  def load_test(times, n_proc, rest_period) do
    for n <- 1..times do
      Logger.info "run #{n}..."
      concurrent_queries(n_proc)
      Logger.info "sleeping..."
      :timer.sleep(rest_period)
    end
  end

  def concurrent_queries(n) do
    try do
      1..n
      |> Enum.map(fn(_) -> Task.async(&exec_query/0) end)
      #|> Enum.map(&Task.await/1)
      :ok
    rescue
      e ->
        Logger.error "error in query: #{inspect(e)}"
        :error
    end
  end

  def exec_query do
    try do
      {name, {query}} = Enum.random(@queries)
      IO.puts "Executing query #{name}"
      Bolt.Sips.conn
      |> Bolt.Sips.query!(query)
    rescue
      _e -> :error
    end
  end
end