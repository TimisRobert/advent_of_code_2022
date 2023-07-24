defmodule Day4 do
  def run do
    input = File.read!("inputs/day4.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.count(&in_range?/1)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.count(&overlap?/1)
  end

  def overlap?([one, two]) do
    not Range.disjoint?(one, two)
  end

  def in_range?([one, two]) do
    Enum.all?(one, &(&1 in two)) or
      Enum.all?(two, &(&1 in one))
  end

  def parse_line(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
  end

  def parse_range(input) do
    input
    |> String.split("-", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [first, last] ->
      Range.new(first, last)
    end)
  end
end
