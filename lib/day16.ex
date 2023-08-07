defmodule Day16 do
  def run do
    input = File.read!("inputs/day16.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
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

  def parse(input) do
    for line <- input |> String.split("\n", trim: true), into: Map.new() do
      split = line |> String.split(" ", trim: true)

      name = split |> Enum.at(1)

      flow =
        split
        |> Enum.at(4)
        |> String.split("=", trim: true)
        |> Enum.at(1)
        |> String.trim_trailing(";")
        |> String.to_integer()

      valves =
        split
        |> Enum.slice(9..-1)
        |> Enum.map(&String.trim_trailing(&1, ","))

      {name, {flow, valves}}
    end
  end

  def walk_path(map, current_path, current_pressure, open_valves) do
  end
end
