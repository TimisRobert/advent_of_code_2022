defmodule Day3 do
  def run do
    input = File.read!("inputs/day3.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  # 65-90 A-Z
  # 97-122 a-z
  def calculate_score(number) when is_integer(number) and number < 97, do: number - 38
  def calculate_score(number) when is_integer(number), do: number - 96
  def calculate_score(number) when is_nil(number), do: 0

  def get_unique_letter(string) do
    [set_one, set_two] =
      string
      |> String.split_at(div(String.length(string), 2))
      |> Tuple.to_list()
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&MapSet.new/1)

    MapSet.intersection(set_one, set_two) |> Enum.at(0)
  end

  def part1(list) do
    list
    |> String.split("\n", trim: true)
    |> Enum.map(&get_unique_letter/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def part2(list) do
    list
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(fn group ->
      [head | tail] =
        group
        |> Enum.map(&String.to_charlist/1)

      tail
      |> Enum.reduce(head, &MapSet.intersection(MapSet.new(&1), MapSet.new(&2)))
      |> Enum.at(0)
    end)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end
end
