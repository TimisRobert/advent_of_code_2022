defmodule Day16 do
  def run do
    input = File.read!("inputs/day16.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end

  def part1(input) do
    input |> parse() |> walk_map()
  end

  def part2(input) do
    0
  end

  def parse(input) do
    lines = input |> String.split("\n", trim: true)

    for line <- lines, into: Map.new() do
      parse_line(line)
    end
  end

  defp parse_line(line) do
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

  def walk_map(
        map,
        current_depth \\ 0,
        current_pressure \\ 0,
        current_path \\ "AA",
        open_valves \\ []
      )

  def walk_map(
        _,
        15,
        current_pressure,
        _,
        open_valves
      ),
      do: current_pressure + Enum.sum(open_valves)

  def walk_map(map, current_depth, current_pressure, current_path, open_valves) do
    {pressure, paths} = Map.get(map, current_path)

    if pressure == 0 do
      paths
      |> Stream.map(
        &walk_map(
          map,
          current_depth + 1,
          current_pressure + Enum.sum(open_valves),
          &1,
          open_valves
        )
      )
      |> Enum.max()
    else
      open_valve =
        walk_map(
          map,
          current_depth + 1,
          current_pressure + Enum.sum(open_valves),
          current_path,
          [pressure | open_valves]
        )

      continue_paths =
        paths
        |> Stream.map(
          &walk_map(
            map,
            current_depth + 1,
            current_pressure + Enum.sum(open_valves),
            &1,
            open_valves
          )
        )
        |> Enum.max()

      max(open_valve, continue_paths)
    end
  end

  def find_shortest_paths(map, start) do
    find_shortest_paths(map, [start], Map.new())
  end

  def find_shortest_paths(_map, [] = _queue, visited) do
    visited
  end

  def find_shortest_paths(map, [head | tail] = _queue, visited) do
    {_, paths} = Map.get(map, head)

    path_values =
      paths
      |> Enum.map(fn path ->
        {value, _} = Map.get(map, path)
        {path, value}
      end)

    visited =
      paths
      |> Enum.reduce(visited, fn path, visited ->
        visited
        |> Map.update(path, [path], fn old -> old end)
      end)

    find_shortest_paths(map, tail ++ paths, visited)
  end
end
