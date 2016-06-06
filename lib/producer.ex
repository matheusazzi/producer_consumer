defmodule Producer do
  def start(manager_pid) do
    spawn(fn -> produce(manager_pid) end)
  end

  defp produce(manager_pid) do
    beer = make_beer
    send(manager_pid, {:beer, beer, self})
    produce(manager_pid)
  end

  defp make_beer do
    beer = round(:rand.uniform * 1000) + 1000
    IO.puts "[P] Produtor #{inspect self} está fazendo cerveja."
    :timer.sleep(beer)
    IO.puts "[P] Produtor #{inspect self} terminou uma cerveja (##{beer})."
    beer
  end
end
