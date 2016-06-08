defmodule Manager do
  def start(producers: num_producers, consumers: num_consumers, buffer_size: buffer_size) do
    Enum.map(1..num_consumers, fn _ -> Consumer.start(self) end)
    Enum.each(1..num_producers, fn _ -> Producer.start(self) end)
    loop([], [])
  end

  defp loop(beers, waiting_consumers) do
    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Consumidor #{inspect consumer_pid} pediu uma cerveja."
        send_beer(beers, consumer_pid, waiting_consumers)

      {:beer, beer, producer_pid} ->
        IO.puts "[M] Cerveja ##{beer} recebida do produtor #{inspect producer_pid}."
        receive_beer(beers, {:beer, beer, producer_pid}, waiting_consumers)
    end
  end

  defp send_beer([], consumer_pid, waiting_consumers) do
    IO.puts "[M] Sem cervejas na fila. Consumidor #{inspect consumer_pid} vai esperar próxima."
    print_beers_list([])
    loop([], waiting_consumers ++ [consumer_pid])
  end

  defp send_beer(beers, consumer_pid, waiting_consumers) do
    first_beer = hd(beers)
    IO.puts "[M] Cerveja ##{elem(first_beer, 1)} enviada ao consumidor #{inspect consumer_pid}."
    send(consumer_pid, first_beer)

    print_beers_list(tl(beers))
    loop(tl(beers), waiting_consumers)
  end

  defp receive_beer(beers, beer, []) do
    beers = beers ++ [beer]
    IO.puts "[M] Cerveja ##{elem(beer, 1)} colocada na fila."
    print_beers_list(beers)
    loop(beers, [])
  end

  defp receive_beer(beers, beer, waiting_consumers) do
    send_beer(beers ++ [beer], hd(waiting_consumers), tl(waiting_consumers))
  end

  defp print_beers_list(beers) do
    printable_list = Enum.map(beers, fn(beer) -> elem(beer, 1) end)
    IO.puts ['Cervejas: ', inspect(printable_list, char_lists: :as_lists)]
  end
end
