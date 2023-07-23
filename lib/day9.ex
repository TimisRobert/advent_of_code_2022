defmodule Day9 do
  def part1(input) do
    input
    |> parse_commands()
    |> count_visited(2)
  end

  def part2(input) do
    input
    |> parse_commands()
    |> count_visited(10)
  end

  def count_visited(commands, number) do
    commands
    |> Enum.reduce(
      %{
        visited: MapSet.new([{0, 0}]),
        knots: Stream.repeatedly(fn -> {0, 0} end) |> Enum.take(number)
      },
      fn [dir, count], map ->
        1..count
        |> Enum.reduce(map, fn _, %{visited: visited, knots: [head | tail]} ->
          head = move_head(dir, head)

          knots =
            tail
            |> Enum.scan(head, fn knot, head ->
              if(close?(head, knot)) do
                knot
              else
                move_tail(head, knot)
              end
            end)

          visited = visited |> MapSet.put(hd(Enum.reverse(knots)))

          %{visited: visited, knots: [head | knots]}
        end)
      end
    )
    |> then(fn %{visited: visited} -> MapSet.size(visited) end)
  end

  def move_head(dir, {head_x, head_y}) do
    case dir do
      "R" ->
        {head_x + 1, head_y}

      "L" ->
        {head_x - 1, head_y}

      "U" ->
        {head_x, head_y + 1}

      "D" ->
        {head_x, head_y - 1}
    end
  end

  def move_tail({head_x, head_y}, {tail_x, tail_y}) do
    cond do
      tail_x == head_x ->
        if tail_y - head_y > 0 do
          {tail_x, tail_y - 1}
        else
          {tail_x, tail_y + 1}
        end

      tail_y == head_y ->
        if tail_x - head_x > 0 do
          {tail_x - 1, tail_y}
        else
          {tail_x + 1, tail_y}
        end

      tail_x - head_x > 0 ->
        if tail_y - head_y > 0 do
          {tail_x - 1, tail_y - 1}
        else
          {tail_x - 1, tail_y + 1}
        end

      tail_x - head_x < 0 ->
        if tail_y - head_y > 0 do
          {tail_x + 1, tail_y - 1}
        else
          {tail_x + 1, tail_y + 1}
        end
    end
  end

  def close?({head_x, head_y}, {tail_x, tail_y}) do
    tail_x in (head_x - 1)..(head_x + 1) and
      tail_y in (head_y - 1)..(head_y + 1)
  end

  def parse_commands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [dir, count] -> [dir, String.to_integer(count)] end)
  end
end

defmodule Mix.Tasks.Day9 do
  use Mix.Task
  import Day9

  @impl Mix.Task
  def run(_args) do
    {:ok, input} = File.read("inputs/day9.txt")
    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end
end
