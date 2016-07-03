defmodule Consumer do
  @moduledoc """
    Consumer just loops through `Consumer.consume/1` method.
    To start a Consumer you must pass a manager PID.

    The `Consumer.start/1` method will spawn a new proccess.

  ## Examples

      iex> Consumer.start(manager_pid)
  """

  def start(manager_pid) do
    spawn(fn -> consume(manager_pid) end)
  end

  # Asks manager for a beer and waits to consume it.
  # Needs manager PID to asks for beer.
  #
  # Expects a tuple as message containing :beer symbol as label, the beer represented as an integer and producer's PID.
  #
  # ## Examples
  #
  #    iex> send(consumer_pid, {:beer, 999, producer_pid})
  defp consume(manager_pid) do
    IO.puts "[C] Consumer #{inspect self} is available."
    send(manager_pid, {:request, self})

    receive do
      {:beer, beer, producer_pid} ->
        IO.puts "[C] Consumer #{inspect self} is drinking a beer ##{beer} from producer #{inspect producer_pid}."
        :timer.sleep(beer)
        IO.puts "[C] Consumer #{inspect self} drank beer."
        consume(manager_pid)
    end
  end
end
