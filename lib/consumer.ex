defmodule Consumer do
  def start(manager_pid) do
    spawn(fn -> consume(manager_pid) end)
  end

  defp consume(manager_pid) do
    IO.puts "[C] Comsumidor #{inspect self} disponível."
    send(manager_pid, {:request, self})

    receive do
      {:beer, beer} ->
        IO.puts "[C] Comsumidor #{inspect self} está consumindo cerveja #{beer}."
        :timer.sleep(beer * 1000)
        consume(manager_pid)
    end
  end
end
