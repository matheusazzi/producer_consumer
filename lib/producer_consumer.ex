defmodule ProducerConsumer do
  def start(num_producers, num_consumers) do
    Enum.map(1..num_consumers, fn _ -> Consumer.start(self) end)
    Enum.each(1..num_producers, fn _ -> Producer.start(self) end)
    loop
  end

  defp loop do
    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Esperando consumidores."
        waiting_next_beer(consumer_pid)

      {:beer, producer_pid, beer} ->
        IO.puts "[M] Esperando cervejas."
        waiting_next_consumer(producer_pid, beer)
    end

    loop
  end

  defp waiting_next_beer(consumer_pid) do
    receive do
      {:beer, producer_pid, beer} ->
        IO.puts "[M] Cerveja #{beer} recebida do produtor #{inspect producer_pid}."
        IO.puts "[M] Cerveja #{beer} enviada ao consumidor #{inspect consumer_pid}."
        send(consumer_pid, {:beer, beer})
    end
  end

  defp waiting_next_consumer(producer_pid, beer) do
    IO.puts "[M] Cerveja #{beer} recebida do produtor #{inspect producer_pid}."

    receive do
      {:request, consumer_pid} ->
        IO.puts "[M] Cerveja #{beer} enviada ao consumidor #{inspect consumer_pid}."
        send(consumer_pid, {:beer, beer})
    end
  end
end

ProducerConsumer.start 3,5
