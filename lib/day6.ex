defmodule Day6 do
  def part1(input) do
    input
    |> String.graphemes()
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.find_index(&(length(Enum.uniq(&1)) === 4))
    |> then(&(&1 + 4))
  end

  def part2(input) do
    input
    |> String.graphemes()
    |> Enum.chunk_every(14, 1, :discard)
    |> Enum.find_index(&(length(Enum.uniq(&1)) === 14))
    |> then(&(&1 + 14))
  end
end

defmodule Mix.Tasks.Day6 do
  use Mix.Task
  import Day6

  @impl Mix.Task
  def run(_args) do
    {:ok, input} = File.read("inputs/day6.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end
end
