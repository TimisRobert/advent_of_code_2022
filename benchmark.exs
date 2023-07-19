defmodule Day4Bench do
  def one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.count(&in_range_one?/1)
  end

  def two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.count(&in_range_two?/1)
  end

  def in_range_one?([one, two]) do
    Enum.all?(one, &(&1 in two)) or
      Enum.all?(two, &(&1 in one))
  end

  def in_range_two?([one, two]) do
    with [one, two] <- [MapSet.new(one), MapSet.new(two)] do
      MapSet.difference(one, two) |> Enum.empty?() or
        MapSet.difference(two, one) |> Enum.empty?()
    end
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

data = File.read!("inputs/day4.txt")

Benchee.run(%{
  "one" => fn -> data |> Day4Bench.one() end,
  "two" => fn -> data |> Day4Bench.two() end
})
