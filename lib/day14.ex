defmodule Day14 do
  @starting_position {500, 0}

  def run do
    input = File.read!("inputs/day14.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    map = parse(input) |> build_map()

    max_depth = find_max_depth(map)

    map
    |> drop_sand(max_depth, max_depth)
    |> Map.filter(fn {_, value} -> value == :sand end)
    |> map_size()
  end

  def part2(input) do
    map = parse(input) |> build_map()

    max_depth = find_max_depth(map)

    map
    |> drop_sand(0, max_depth + 1)
    |> Map.filter(fn {_, value} -> value == :sand end)
    |> map_size()
  end

  def find_max_depth(map) do
    map |> Map.keys() |> Enum.max_by(fn {_, y} -> y end) |> then(&elem(&1, 1))
  end

  def drop_sand(map, target_y, max_depth) do
    case next_position(map, @starting_position, max_depth) do
      {_, ^target_y} ->
        map

      position ->
        map
        |> Map.put(position, :sand)
        |> drop_sand(target_y, max_depth)
    end
  end

  def next_position(map, {x, y}, max_depth) do
    cond do
      y == max_depth ->
        {x, y}

      Map.get(map, {x, y + 1}) == nil ->
        next_position(map, {x, y + 1}, max_depth)

      Map.get(map, {x - 1, y + 1}) == nil ->
        next_position(map, {x - 1, y + 1}, max_depth)

      Map.get(map, {x + 1, y + 1}) == nil ->
        next_position(map, {x + 1, y + 1}, max_depth)

      true ->
        {x, y}
    end
  end

  def build_map(lines) do
    lines
    |> Enum.flat_map(&build_lines/1)
    |> Map.new()
  end

  defp build_lines(points) do
    points
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(&build_line/1)
  end

  defp build_line([{start_x, start_y}, {end_x, end_y}]) do
    for x <- start_x..end_x do
      for y <- start_y..end_y do
        {{x, y}, :rock}
      end
    end
    |> List.flatten()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ", trim: true)
    |> Enum.map(&parse_pair/1)
  end

  defp parse_pair(pair) do
    pair
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(&List.to_tuple/1)
  end
end
