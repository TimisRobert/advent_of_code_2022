defmodule Day15 do
  def run do
    input = File.read!("inputs/day15.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end

  def part1(input) do
    input
    |> parse()
    |> Stream.map(&range_x(&1, 2_000_000))
    |> Stream.filter(&(not is_nil(&1)))
    |> then(&merge_ranges/1)
    |> then(fn [min..max] -> max - min end)
  end

  def part2(input) do
    input
    |> parse()
    |> find_gap(4_000_000)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_coords/1)
  end

  def parse_coords(input) do
    Regex.scan(~r/-?[0-9]+/, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def find_gap(list, max) do
    0..max
    |> Enum.find_value(fn y ->
      ranges =
        list
        |> Enum.map(&range_x(&1, y))
        |> Stream.filter(&(not is_nil(&1)))
        |> then(&merge_ranges/1)

      if length(ranges) == 2 do
        [x_one.._, _.._] = ranges

        (x_one - 1) * 4_000_000 + y
      end
    end)
  end

  defp merge_ranges(ranges) do
    [h | t] = Enum.sort(ranges)
    do_merge_ranges(t, [h])
  end

  defp do_merge_ranges([s2..e2 | t2], [s1..e1 | t1]) when s2 <= e1 + 1 do
    do_merge_ranges(t2, [s1..max(e1, e2) | t1])
  end

  defp do_merge_ranges([range2 | t2], acc) do
    do_merge_ranges(t2, [range2 | acc])
  end

  defp do_merge_ranges([], acc), do: acc

  def range_x({{s_x, s_y}, _} = coord, y) do
    d = manhattan_distance(coord)

    if y in (s_y - d)..(s_y + d) do
      (s_x - (d - abs(s_y - y)))..(s_x + (d - abs(s_y - y)))
    end
  end

  def manhattan_distance({{s_x, s_y}, {b_x, b_y}}) do
    abs(s_x - b_x) + abs(s_y - b_y)
  end
end
