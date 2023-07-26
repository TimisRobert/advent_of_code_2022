defmodule Day12 do
  def run do
    input = File.read!("inputs/day12.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    grid =
      input
      |> parse_grid()

    {start, grid} = find_start(grid)
    {goal, grid} = find_goal(grid)

    walk_grid(grid, [{start, 0}]) |> get_in([goal, :distance])
  end

  def part2(input) do
    grid =
      input
      |> parse_grid()

    {_start, grid} = find_start(grid)
    {goal, grid} = find_goal(grid)

    starts =
      grid
      |> Enum.filter(fn {_, %{height: height}} ->
        height == ?a
      end)
      |> Enum.map(fn {pos, _} -> {pos, 0} end)

    walk_grid(grid, starts) |> get_in([goal, :distance])
  end

  def walk_grid(grid, []) do
    grid
  end

  def walk_grid(grid, [{position, distance} | rest]) do
    if get_in(grid, [position, :distance]) == :unknown do
      grid = put_in(grid, [position, :distance], distance)
      steps = get_valid_steps(grid, position) |> Enum.map(&{&1, distance + 1})
      walk_grid(grid, rest ++ steps)
    else
      walk_grid(grid, rest)
    end
  end

  def get_valid_steps(grid, {x, y} = current) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(fn future ->
      Map.has_key?(grid, future) and
        get_in(grid, [future, :height]) - get_in(grid, [current, :height]) <= 1
    end)
  end

  def find_start(grid) do
    position = Enum.find_value(grid, fn {pos, %{height: height}} -> if height == ?S, do: pos end)

    {position, grid |> Map.replace!(position, %{height: ?a, distance: :unknown})}
  end

  def find_goal(grid) do
    position = Enum.find_value(grid, fn {pos, %{height: height}} -> if height == ?E, do: pos end)

    {position, grid |> Map.replace!(position, %{height: ?z, distance: :unknown})}
  end

  def parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, map ->
      row
      |> Enum.reduce(map, fn {col, j}, acc ->
        acc
        |> Map.put({j, i}, %{height: col, distance: :unknown})
      end)
    end)
  end
end
