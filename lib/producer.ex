defmodule Producer do
  @moduledoc """
    Producers can produce beers through `produce/1` private method.
    To start a Producer you must pass a manager PID.

    The `Producer.start/1` method will spawn a new proccess.

  ## Examples

      iex> Producer.start(manager_pid)
  """

  def start(manager_pid) do
    spawn(fn -> produce(manager_pid) end)
  end

  defp produce(manager_pid) do
    beer = make_beer
    send(manager_pid, {:beer, beer, self})
    produce(manager_pid)
  end

  # Randomizes a number and uses it as the time to produce the beer.
  # Returns the beer (a number). e.g. #=> 1999
  defp make_beer do
    beer = round(:rand.uniform * 1000) + 1000
    IO.puts "[P] Producer #{inspect self} is making a beer."
    :timer.sleep(beer)
    IO.puts "[P] Producer #{inspect self} finished a beer (##{beer})."
    beer
  end
end
