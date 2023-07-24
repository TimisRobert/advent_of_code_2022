defmodule Day8 do
  def run do
    input = File.read!("inputs/day8.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    input
    |> parse_grid()
    |> count_visible()
  end

  def part2(input) do
    input
    |> parse_grid()
    |> calculate_scenic()
  end

  def calculate_scenic(grid) do
    grid
    |> Enum.map(fn {{x, y}, value} ->
      up =
        grid
        |> Enum.filter(fn {{i, j}, _} -> j < y and i == x end)
        |> Enum.sort(fn {{_, i}, _}, {{_, j}, _} -> i > j end)
        |> Enum.reduce_while(0, fn {_, v}, acc ->
          cond do
            v < value -> {:cont, acc + 1}
            v >= value -> {:halt, acc + 1}
          end
        end)

      down =
        grid
        |> Enum.filter(fn {{i, j}, _} -> j > y and i == x end)
        |> Enum.sort(fn {{_, i}, _}, {{_, j}, _} -> j > i end)
        |> Enum.reduce_while(0, fn {_, v}, acc ->
          cond do
            v < value -> {:cont, acc + 1}
            v >= value -> {:halt, acc + 1}
          end
        end)

      right =
        grid
        |> Enum.filter(fn {{i, j}, _} -> i > x and j == y end)
        |> Enum.sort(fn {{i, _}, _}, {{j, _}, _} -> j > i end)
        |> Enum.reduce_while(0, fn {_, v}, acc ->
          cond do
            v < value -> {:cont, acc + 1}
            v >= value -> {:halt, acc + 1}
          end
        end)

      left =
        grid
        |> Enum.filter(fn {{i, j}, _} -> i < x and j == y end)
        |> Enum.sort(fn {{i, _}, _}, {{j, _}, _} -> i > j end)
        |> Enum.reduce_while(0, fn {_, v}, acc ->
          cond do
            v < value -> {:cont, acc + 1}
            v >= value -> {:halt, acc + 1}
          end
        end)

      up * down * right * left
    end)
    |> Enum.max()
  end

  def count_visible(grid) do
    grid
    |> Enum.count(fn {{x, y}, value} ->
      up =
        grid
        |> Enum.filter(fn {{i, j}, _} -> j < y and i == x end)
        |> Enum.all?(fn {_, v} -> v < value end)

      down =
        grid
        |> Enum.filter(fn {{i, j}, _} -> j > y and i == x end)
        |> Enum.all?(fn {_, v} -> v < value end)

      right =
        grid
        |> Enum.filter(fn {{i, j}, _} -> i > x and j == y end)
        |> Enum.all?(fn {_, v} -> v < value end)

      left =
        grid
        |> Enum.filter(fn {{i, j}, _} -> i < x and j == y end)
        |> Enum.all?(fn {_, v} -> v < value end)

      up or down or right or left
    end)
  end

  def parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, map ->
      row
      |> Enum.reduce(map, fn {col, j}, acc ->
        acc
        |> Map.put({j, i}, col |> String.to_integer())
      end)
    end)
  end
end
