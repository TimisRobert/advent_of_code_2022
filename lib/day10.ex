defmodule Day10 do
  def run do
    input = File.read!("inputs/day10.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    input
    |> parse_instr()
    |> build_pipeline()
    |> run_pipeline()
    |> then(&elem(&1, 2))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_instr()
    |> build_pipeline()
    |> draw_screen()
    |> then(&elem(&1, 2))
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map_join("\n", &Enum.join/1)
  end

  def draw_screen(pipeline) do
    pipeline
    |> Enum.reduce({1, 1, []}, fn instr, {cycle, x, screen} ->
      screen =
        if rem(cycle, 40) in x..(x + 2) do
          ["#" | screen]
        else
          ["." | screen]
        end

      x =
        case instr do
          {"noop"} -> x
          {"addx", value} -> x + value
        end

      {cycle + 1, x, screen}
    end)
  end

  def run_pipeline(pipeline) do
    pipeline
    |> Enum.reduce({1, 1, []}, fn instr, {cycle, x, results} ->
      results =
        if cycle in 20..220//40 do
          [cycle * x | results]
        else
          results
        end

      x =
        case instr do
          {"noop"} -> x
          {"addx", value} -> x + value
        end

      {cycle + 1, x, results}
    end)
  end

  def build_pipeline(instructions) do
    instructions
    |> Enum.reduce([], fn instr, acc ->
      case instr do
        {"noop"} -> [instr | acc]
        {"addx", _} -> [instr | [{"noop"} | acc]]
      end
    end)
    |> Enum.reverse()
  end

  def parse_instr(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn
      [instr, value] -> {instr, String.to_integer(value)}
      [instr] -> {instr}
    end)
  end
end
