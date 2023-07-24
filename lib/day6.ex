defmodule Day6 do
  def run do
    input = File.read!("inputs/day6.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

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
