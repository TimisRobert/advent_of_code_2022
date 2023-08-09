defmodule Day16 do
  def run do
    input = File.read!("inputs/day16.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end

  def part1(input) do
    input |> parse() |> find_best_path()
  end

  def part2(input) do
    input |> parse() |> find_best_path_duo()
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

  def find_best_path(map) do
    keys =
      map
      |> Map.filter(fn {key, {pressure, _}} ->
        key == "AA" or pressure > 0
      end)
      |> Map.keys()

    shortest_paths = calc_all_shortest_paths(map, keys)

    find_best_path(map, shortest_paths, ["AA"], 30, 0)
  end

  def find_best_path_duo(map) do
    keys =
      map
      |> Map.filter(fn {key, {pressure, _}} ->
        key == "AA" or pressure > 0
      end)
      |> Map.keys()

    shortest_paths = calc_all_shortest_paths(map, keys)

    # find_all_best_paths(map, shortest_paths, ["AA"], 26, 0) |> Enum.take(1000)
  end

  def find_best_path(
        map,
        shortest_paths,
        [current_path | _] = open_valves,
        current_time,
        current_pressure
      ) do
    shortest_paths
    |> Map.get(current_path, [])
    |> Stream.filter(fn {path, distance} ->
      remaining_time = current_time - distance - 1

      remaining_time > 0 and path not in open_valves
    end)
    |> Stream.map(fn {path, distance} ->
      remaining_time = current_time - distance - 1
      {pressure, _} = Map.get(map, path)

      find_best_path(
        map,
        shortest_paths,
        [path | open_valves],
        remaining_time,
        current_pressure + pressure * remaining_time
      )
    end)
    |> Enum.max(fn -> current_pressure end)
  end

  def calc_all_shortest_paths(map, keys) do
    for key <- keys, reduce: %{} do
      acc ->
        acc
        |> Map.merge(%{key => calc_shortest_paths(map, [key], %{key => 0})})
    end
  end

  def calc_shortest_paths(map, [head | tail] = _queue, visited) do
    {_, edges} = Map.get(map, head)

    to_visit =
      edges
      |> Enum.filter(fn edge ->
        Map.get(visited, edge) == nil
      end)

    visited =
      edges
      |> Enum.reduce(visited, fn edge, visited ->
        from_parent = Map.get(visited, head, 0) + 1

        visited
        |> Map.update(edge, from_parent, &if(from_parent < &1, do: from_parent, else: &1))
      end)

    calc_shortest_paths(map, tail ++ to_visit, visited)
  end

  def calc_shortest_paths(_map, [] = _queue, visited) do
    visited
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
