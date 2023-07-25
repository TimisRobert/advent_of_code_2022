defmodule Day11 do
  alias Day11.Monkey

  @registry :registry

  def run do
    input = File.read!("inputs/day11.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    Registry.start_link(keys: :unique, name: @registry)

    input
    |> parse_input()
    |> spawn_agents()
    |> run_simulation(20)
  end

  def part2(input) do
    Registry.start_link(keys: :unique, name: @registry)

    divisor =
      input
      |> calculate_divisor()

    input
    |> parse_input(divisor)
    |> spawn_agents()
    |> run_simulation(10_000)
  end

  def run_simulation({:ok, pid}, times) do
    for _n <- 1..times do
      for id <- 0..7 do
        Monkey.run("Monkey #{id}")
      end
    end

    seen =
      for id <- 0..7 do
        Monkey.get_seen("Monkey #{id}")
      end

    Supervisor.stop(pid)

    seen
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def spawn_agents(initial_states) do
    initial_states
    |> Enum.map(&Supervisor.child_spec({Monkey, &1}, id: &1.id))
    |> Supervisor.start_link(strategy: :one_for_all)
  end

  def parse_input(input, divisor \\ 3) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn monkey ->
      [
        name,
        items,
        operation | test
      ] =
        monkey
        |> String.split("\n", trim: true)
        |> Enum.flat_map(&String.split(&1, ": ", trim: true))
        |> Enum.take_every(2)

      %{
        id: name |> String.trim_trailing(":") |> String.split() |> then(&Enum.at(&1, 1)),
        name: name |> String.trim_trailing(":"),
        items: items |> parse_items(),
        operation: operation |> parse_operation(divisor),
        test: test |> parse_test()
      }
    end)
  end

  def calculate_divisor(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn monkey ->
      [
        _,
        _,
        _ | test
      ] =
        monkey
        |> String.split("\n", trim: true)
        |> Enum.flat_map(&String.split(&1, ": ", trim: true))
        |> Enum.take_every(2)

      test |> parse_divisor()
    end)
    |> Enum.product()
  end

  def parse_items(items) do
    items
    |> String.split(", ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_divisor([cond, _, _]) do
    cond |> String.split(" ", trim: true) |> List.last() |> String.to_integer()
  end

  def parse_test([cond, yes, no]) do
    cond = cond |> String.split(" ", trim: true) |> List.last() |> String.to_integer()
    yes = yes |> String.split(" ", trim: true) |> List.last() |> String.to_integer()
    no = no |> String.split(" ", trim: true) |> List.last() |> String.to_integer()

    fn x ->
      if rem(x, cond) == 0,
        do: Monkey.add_item("Monkey #{yes}", x),
        else: Monkey.add_item("Monkey #{no}", x)
    end
  end

  def parse_operation(operation, divisor) do
    operation
    |> String.split("= ", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(&String.split(&1, " ", trim: true))
    |> then(fn
      [_, "*", "old"] when divisor == 3 -> fn x -> div(x * x, divisor) end
      [_, "*", "old"] -> fn x -> rem(x * x, divisor) end
      [_, "+", "old"] when divisor == 3 -> fn x -> div(x + x, divisor) end
      [_, "+", "old"] -> fn x -> rem(x + x, divisor) end
      [_, "*", two] when divisor == 3 -> fn x -> div(x * String.to_integer(two), divisor) end
      [_, "*", two] -> fn x -> rem(x * String.to_integer(two), divisor) end
      [_, "+", two] when divisor == 3 -> fn x -> div(x + String.to_integer(two), divisor) end
      [_, "+", two] -> fn x -> rem(x + String.to_integer(two), divisor) end
    end)
  end
end

defmodule Day11.Monkey do
  use Agent

  @registry :registry

  def start_link(%{name: name, items: _, operation: _, test: _} = initial_value) do
    Agent.start_link(
      fn ->
        initial_value |> Map.put(:seen, 0)
      end,
      name: {:via, Registry, {@registry, name}}
    )
  end

  def get_items(name) do
    Agent.get({:via, Registry, {@registry, name}}, fn map -> map.items end)
  end

  def get_seen(name) do
    Agent.get({:via, Registry, {@registry, name}}, fn map -> map.seen end)
  end

  def add_item(name, item) do
    Agent.update(
      {:via, Registry, {@registry, name}},
      fn map ->
        map |> Map.update!(:items, &(&1 ++ [item]))
      end
    )
  end

  def run(name) do
    Agent.update(
      {:via, Registry, {@registry, name}},
      fn map ->
        items = map |> Map.fetch!(:items)

        len =
          length(
            for item <- items do
              item
              |> map.operation.()
              |> map.test.()
            end
          )

        map
        |> Map.update!(:seen, &(&1 + len))
        |> Map.replace!(:items, [])
      end
    )
  end
end
