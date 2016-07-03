defmodule Manager do
  @moduledoc """
    Manager module is a way to start and connect producers and consumers.
    Provides `Manager.start/3` as a public function to initiaze the manager.

    The `Manager.start/3` function will initializes a number of producers and consumers calling their `start` function too.
    Also, it will call `Manager.loop/3` private function with an empty initial state and the buffer size.

    ## Examples

        iex> Manager.start(producers: 3, consumers: 4, buffer_size: 5)
  """

  def start(producers: num_producers, consumers: num_consumers, buffer_size: buffer_size) do
    Enum.map(1..num_consumers, fn _ -> Consumer.start(self) end)
    Enum.map(1..num_producers, fn _ -> Producer.start(self) end)
    loop([], [], buffer_size)
  end

  # Will wait messages from Producers and/or Consumers
  defp loop(beers, waiting_consumers, buffer_size) do
    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Consumer #{inspect consumer_pid} asked for a beer."
        send_beer(beers, consumer_pid, waiting_consumers, buffer_size)

      {:beer, beer, producer_pid} ->
        IO.puts "[M] Beer ##{beer} received from producer #{inspect producer_pid}."

        if length(beers) >= buffer_size do
          list_is_full(beers, beer, waiting_consumers, buffer_size)
        else
          receive_beer(beers, {:beer, beer, producer_pid}, waiting_consumers, buffer_size)
        end
    end
  end

  # No beers
  defp send_beer([], consumer_pid, waiting_consumers, buffer_size) do
    IO.puts "[M] No beers in the queue. Consumer #{inspect consumer_pid} will wait for next."
    print_beers_list([], buffer_size)
    loop([], waiting_consumers ++ [consumer_pid], buffer_size)
  end

  # Has beers
  defp send_beer([head_beer | tail_beers], consumer_pid, waiting_consumers, buffer_size) do
    IO.puts "[M] Beer ##{elem(head_beer, 1)} sent to consumer #{inspect consumer_pid}."
    send(consumer_pid, head_beer)

    print_beers_list(tail_beers, buffer_size)
    loop(tail_beers, waiting_consumers, buffer_size)
  end

  # No waiting consumers
  defp receive_beer(beers, beer, [], buffer_size) do
    beers = beers ++ [beer]
    IO.puts "[M] Beer ##{elem(beer, 1)} queued."
    print_beers_list(beers, buffer_size)
    loop(beers, [], buffer_size)
  end

  # There are waiting consumers
  defp receive_beer(beers, beer, [head_consumer | tail_consumers], buffer_size) do
    send_beer(beers ++ [beer], head_consumer, tail_consumers, buffer_size)
  end

  # Buffer is full
  defp list_is_full(beers, beer, waiting_consumers, buffer_size) do
    IO.puts "[M] Beers queue is full. Beer ##{beer} was discarded."
    print_beers_list(beers, buffer_size)
    loop(beers, waiting_consumers, buffer_size)
  end

  # Prints the beers list in a pretty formatted way.
  #
  # ## Examples
  #    iex> print_beers_list([{:beer, 100, pid1}, {:beer, 400, pid2}], 5)
  #    > "Beers: [100, 400] Qtd: 2/5"
  defp print_beers_list(beers, buffer_size) do
    printable_list = Enum.map(beers, fn(beer) -> elem(beer, 1) end)
    IO.puts ['Beers: ', inspect(printable_list, char_lists: :as_lists), " Qtd: #{length(beers)}/#{buffer_size}"]
  end
end
