defmodule Manager do
  @moduledoc """
    Manager module is a way to start and connect producers and consumers.
    Provides `Manager.start/3` as a public method to initiaze the manager.
  """

  @doc """
  It initializes a number of producers and consumers calling their start method.
  Assigns the buffer limit size and call `Manager.loop/3` private method with an empty initial state.

  ## Examples

      iex> Manager.start(producers: 3, consumers: 4, buffer_size: 5)
  """
  def start(producers: num_producers, consumers: num_consumers, buffer_size: buffer_size) do
    Enum.map(1..num_consumers, fn _ -> Consumer.start(self) end)
    Enum.map(1..num_producers, fn _ -> Producer.start(self) end)
    loop([], [], buffer_size)
  end

  @doc """
  Will wait messages from Producers and/or Consumers
  """
  defp loop(beers, waiting_consumers, buffer_size) do
    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Consumidor #{inspect consumer_pid} pediu uma cerveja."
        send_beer(beers, consumer_pid, waiting_consumers, buffer_size)

      {:beer, beer, producer_pid} ->
        IO.puts "[M] Cerveja ##{beer} recebida do produtor #{inspect producer_pid}."

        if length(beers) >= buffer_size do
          list_is_full(beers, beer, waiting_consumers, buffer_size)
        else
          receive_beer(beers, {:beer, beer, producer_pid}, waiting_consumers, buffer_size)
        end
    end
  end

  # No beers
  defp send_beer([], consumer_pid, waiting_consumers, buffer_size) do
    IO.puts "[M] Sem cervejas na fila. Consumidor #{inspect consumer_pid} vai esperar próxima."
    print_beers_list([], buffer_size)
    loop([], waiting_consumers ++ [consumer_pid], buffer_size)
  end

  # Has beers
  defp send_beer(beers, consumer_pid, waiting_consumers, buffer_size) do
    first_beer = hd(beers)
    IO.puts "[M] Cerveja ##{elem(first_beer, 1)} enviada ao consumidor #{inspect consumer_pid}."
    send(consumer_pid, first_beer)

    print_beers_list(tl(beers), buffer_size)
    loop(tl(beers), waiting_consumers, buffer_size)
  end

  # No waiting consumers
  defp receive_beer(beers, beer, [], buffer_size) do
    beers = beers ++ [beer]
    IO.puts "[M] Cerveja ##{elem(beer, 1)} colocada na fila."
    print_beers_list(beers, buffer_size)
    loop(beers, [], buffer_size)
  end

  # There are waiting consumers
  defp receive_beer(beers, beer, waiting_consumers, buffer_size) do
    send_beer(beers ++ [beer], hd(waiting_consumers), tl(waiting_consumers), buffer_size)
  end

  # Buffer is full
  defp list_is_full(beers, beer, waiting_consumers, buffer_size) do
    IO.puts "[M] Fila de cervejas já está cheia. Cerveja ##{beer} descartada."
    print_beers_list(beers, buffer_size)
    loop(beers, waiting_consumers, buffer_size)
  end

  @doc """
  Prints the beers list in a pretty formatted way.

  Returns `:ok`.

  ## Examples

      iex> print_beers_list([{:beer, 100, pid1}, {:beer, 400, pid2}], 5)
  """
  defp print_beers_list(beers, buffer_size) do
    printable_list = Enum.map(beers, fn(beer) -> elem(beer, 1) end)
    IO.puts ['Cervejas: ', inspect(printable_list, char_lists: :as_lists), " Qtd: #{length(beers)}/#{buffer_size}"]
  end
end
