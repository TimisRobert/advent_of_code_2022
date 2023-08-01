defmodule Day13 do
  defguard xor(a, b) when (a or b) and not (a and b)

  def run do
    input = File.read!("inputs/day13.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    input
    |> parse_input()
    |> find_valid_pairs()
  end

  def part2(input) do
    input
    |> parse_all_input()
    |> Enum.concat([[[2]], [[6]]])
    |> Enum.sort_by(&Function.identity/1, &compare/2)
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {x, idx} ->
      if x in [[[2]], [[6]]], do: [idx], else: []
    end)
    |> Enum.product()
  end

  def find_valid_pairs(list) do
    list
    |> Enum.with_index(1)
    |> Enum.filter(fn {[left, right], _} -> compare(left, right) end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def compare([], []),
    do: nil

  def compare(_, []),
    do: false

  def compare([], _),
    do: true

  def compare(left, right)
      when is_integer(left) and is_integer(right) and left == right,
      do: nil

  def compare(left, right)
      when is_integer(left) and is_integer(right),
      do: left < right

  def compare(left, right)
      when xor(is_integer(left), is_integer(right)),
      do: compare(List.wrap(left), List.wrap(right))

  def compare([first_left | rest_left], [first_right | rest_right]) do
    case compare(first_left, first_right) do
      nil ->
        compare(rest_left, rest_right)

      pair ->
        pair
    end
  end

  def parse_all_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&Code.string_to_quoted!/1)
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn block ->
      block |> String.split("\n", trim: true) |> Enum.map(&Code.string_to_quoted!/1)
    end)
  end
end
