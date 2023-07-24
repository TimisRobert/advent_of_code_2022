defmodule Day2 do
  # 0 rock
  # 1 paper
  # 2 scissors

  # if(x == y + 1 % 3)

  @score %{
    "A" => 0,
    "X" => 0,
    "B" => 1,
    "Y" => 1,
    "C" => 2,
    "Z" => 2
  }

  @order ["A", "B", "C"]

  @loss 0
  @draw 3
  @win 6

  @outcome %{
    "X" => -1,
    "Y" => 0,
    "Z" => 1
  }

  def run do
    input = File.read!("inputs/day2.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  def part1(input) do
    parse(input)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def part2(input) do
    parse(input)
    |> Enum.map(&calculate_result/1)
    |> Enum.sum()
  end

  def calculate_score([their, mine]) do
    their_score = @score[their]
    mine_score = @score[mine]

    cond do
      mine_score == their_score -> @draw
      mine_score == rem(their_score + 1, 3) -> @win
      true -> @loss
    end + mine_score + 1
  end

  def calculate_result([their, mine]) do
    their_score = @score[their]
    mine_pick = @order |> Enum.at(rem(@outcome[mine] + their_score, 3))
    mine_score = @score[mine_pick]

    cond do
      mine_score == their_score -> @draw
      mine_score == rem(their_score + 1, 3) -> @win
      true -> @loss
    end + mine_score + 1
  end
end
