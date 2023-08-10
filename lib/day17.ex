defmodule Day17 do
  @shapes [
    # - shape
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    # + shape
    [{0, 1}, {1, 1}, {2, 1}, {1, 0}, {1, 2}],
    # L shape
    [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}],
    # I shape
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    # o shape
    [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  ]

  def run do
    input = File.read!("inputs/day17.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end

  def part1(input) do
    input |> parse() |> Enum.max()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def calculate(wind) do
    wind = Stream.cycle(wind)
    map = 0..6 |> Enum.map(&{&1, -1}) |> MapSet.new()

    @shapes
    |> Stream.cycle()
    |> Stream.scan({map, 0}, &drop_shape(wind, &1, &2))
  end

  defp drop_shape(wind, shape, {map, wind_index}) do
    {_, y} = map |> Enum.max_by(fn {_, y} -> y end)
    shape = shape |> shift_shape(2, y + 4)

    wind
    |> Stream.drop(wind_index)
    |> Enum.reduce_while({shape, map, wind_index}, fn wind, {shape, map, wind_index} ->
      shape = shape |> wind_shift(wind)

      if shape_collided?(map, shape |> shift_shape(0, -1)) do
        {:halt, {shape |> MapSet.new() |> MapSet.union(map), wind_index + 1}}
      else
        {:cont, {shape |> shift_shape(0, -1), map, wind_index + 1}}
      end
    end)
  end

  defp shape_collided?(map, shape) do
    MapSet.new(shape) |> MapSet.intersection(map) == MapSet.new()
  end

  defp shift_shape(shape, x_shift, y_shift) do
    {x, _} = shape |> Enum.max_by(fn {x, _} -> x end)
    x_shift = x_shift |> min(6) |> max(0)

    shape
    |> Enum.map(fn {x, y} -> {min(6, x + x_shift) |> max(0), y + y_shift} end)
  end

  defp wind_shift(shape, wind) do
    case wind do
      "<" -> shape |> shift_shape(-1, 0)
      ">" -> shape |> shift_shape(1, 0)
    end
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end
end
