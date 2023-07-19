defmodule Day5 do
  def split_input(input) do
    input |> String.split("\n\n", trim: true)
  end

  def parse_crates(input) do
  end
end

defmodule Mix.Tasks.Day5 do
  use Mix.Task
  import Day5

  @impl Mix.Task
  def run(_args) do
    {:ok, input} = File.read("inputs/day5.txt")
    # input |> part1() |> IO.puts()
    # input |> part2() |> IO.puts()
  end
end
