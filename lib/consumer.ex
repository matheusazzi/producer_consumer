defmodule Consumer do
  def start(manager_pid) do
    spawn(fn -> consume(manager_pid) end)
  end

  defp consume(manager_pid) do
    IO.puts "[C] Consumidor #{inspect self} está disponível."
    send(manager_pid, {:request, self})

    receive do
      {:beer, beer, producer_pid} ->
        IO.puts "[C] Consumidor #{inspect self} consumindo cerveja ##{beer} do Produtor #{inspect producer_pid}."
        :timer.sleep(beer)
        IO.puts "[C] Consumidor #{inspect self} consumiu cerveja."
        consume(manager_pid)
    end
  end
end
