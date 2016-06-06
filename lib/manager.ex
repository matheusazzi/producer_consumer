defmodule Manager do
  def start(num_producers, num_consumers) do
    Enum.map(1..num_consumers, fn _ -> Consumer.start(self) end)
    Enum.each(1..num_producers, fn _ -> Producer.start(self) end)
    loop([], [])
  end

  defp loop(beers, free_consumers) do
    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Consumidor #{inspect consumer_pid} pediu uma cerveja."
        send_beer(beers, consumer_pid, free_consumers)

      {:beer, beer, producer_pid} ->
        IO.puts "[M] Cerveja ##{beer} recebida do produtor #{inspect producer_pid}."
        receive_beer(beers, {:beer, beer, producer_pid}, free_consumers)
    end
  end

  defp send_beer([], consumer_pid, free_consumers) do
    IO.puts "[M] Sem cervejas na fila. Consumidor #{inspect consumer_pid} vai esperar próxima."
    print_beers_list([])
    loop([], free_consumers ++ [consumer_pid])
  end

  defp send_beer(beers, consumer_pid, free_consumers) do
    first_beer = hd(beers)
    IO.puts "[M] Cerveja ##{elem(first_beer, 1)} enviada ao consumidor #{inspect consumer_pid}."
    send(consumer_pid, first_beer)

    print_beers_list(tl(beers))
    loop(tl(beers), free_consumers)
  end

  defp receive_beer(beers, beer, []) do
    beers = beers ++ [beer]
    IO.puts "[M] Cerveja ##{elem(beer, 1)} colocada na fila."
    print_beers_list(beers)
    loop(beers, [])
  end

  defp receive_beer(beers, beer, free_consumers) do
    send_beer(beers ++ [beer], hd(free_consumers), tl(free_consumers))
  end

  defp print_beers_list(beers) do
    IO.inspect({:beers, beers}, char_lists: :as_lists)
  end
end

# Manager.start(1, 1)
