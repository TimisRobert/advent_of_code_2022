defmodule Day1 do
  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn x ->
      x
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end

  def part1(input) do
    parse(input) |> Enum.max()
  end

  def part2(input) do
    parse(input)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day1 do
  use Mix.Task

  import Day1

  @impl Mix.Task
  def run(_args) do
    {:ok, input} = File.read("inputs/day1.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end
end
