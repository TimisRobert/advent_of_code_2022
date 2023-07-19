defmodule Day5 do
  def part1(input) do
    [stacks, commands] =
      input
      |> split_input()

    stacks = parse_crates(stacks)
    commands = parse_commands(commands)
    map = run_commands(stacks, commands, false)

    map |> Map.values() |> pop_lists()
  end

  def part2(input) do
    [stacks, commands] =
      input
      |> split_input()

    stacks = parse_crates(stacks)
    commands = parse_commands(commands)
    map = run_commands(stacks, commands, true)

    map |> Map.values() |> pop_lists()
  end

  def split_input(input) do
    input |> String.split("\n\n", trim: true)
  end

  def parse_crates(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.map(fn line ->
      line
      |> String.to_charlist()
      |> Enum.drop(1)
      |> Enum.chunk_every(1, 4)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reject(&1, fn x -> x == ' ' end))
    |> Enum.with_index(1)
    |> Map.new(fn {v, k} -> {k, Enum.reverse(v)} end)
  end

  def parse_commands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn command ->
      String.split(command, " ", trim: true)
      |> Enum.drop(1)
      |> Enum.take_every(2)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def run_commands(stacks, commands, ordered) do
    commands
    |> Enum.reduce(stacks, fn curr, acc ->
      [quantity, from, to] = curr

      {removed, new} =
        acc
        |> Map.get(from)
        |> Enum.split(quantity)

      acc
      |> Map.replace(
        to,
        if(ordered, do: removed, else: Enum.reverse(removed)) ++ Map.get(acc, to)
      )
      |> Map.replace(from, new)
    end)
  end

  def pop_lists(lists) do
    lists
    |> Enum.flat_map(fn list -> Enum.take(list, 1) end)
    |> Enum.join()
  end
end

defmodule Mix.Tasks.Day5 do
  use Mix.Task
  import Day5

  @impl Mix.Task
  def run(_args) do
    {:ok, input} = File.read("inputs/day5.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end
end
