defmodule Day7 do
  def run do
    input = File.read!("inputs/day7.txt")
    part1(input) |> IO.puts()
    part2(input) |> IO.puts()
  end

  def part1(input) do
    input
    |> parse_command_groups()
    |> build_tree()
    |> reduce_tree()
    |> Enum.map(&elem(&1, 1))
    |> Enum.reject(&(&1 > 100_000))
    |> Enum.sum()
  end

  def part2(input) do
    tree =
      input
      |> parse_command_groups()
      |> build_tree()
      |> reduce_tree()

    root = tree |> Map.get("/")

    tree
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&(70_000_000 - root + &1 >= 30_000_000))
    |> Enum.min()
  end

  def reduce_tree(tree, map \\ %{}, dir \\ "") do
    tree
    |> Enum.reduce(map, fn node, acc ->
      case node do
        {dirname, children} when is_map(children) ->
          reduce_tree(children, acc, dir <> dirname)
          |> Map.merge(Map.new([{dir <> dirname, compute_sizes(children)}]))

        _ ->
          acc
      end
    end)
  end

  def compute_sizes(tree) do
    tree
    |> Enum.reduce(0, fn entry, total ->
      case(entry) do
        {_, size} when is_integer(size) ->
          size + total

        {_, children} ->
          total + compute_sizes(children)
      end
    end)
  end

  def parse_command_groups(input) do
    input
    |> String.split("$", trim: true)
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
    end)
    |> Enum.map(fn commands ->
      commands
      |> Enum.map(&String.trim/1)
    end)
  end

  def build_tree(command_groups) do
    command_groups
    |> Enum.reduce(
      %{file_tree: %{}, dir_stack: []},
      fn command_group,
         %{
           file_tree: file_tree,
           dir_stack: dir_stack
         } = map ->
        case command_group do
          ["cd .."] ->
            %{map | dir_stack: dir_stack |> List.pop_at(0) |> elem(1)}

          ["cd " <> dir] ->
            %{map | dir_stack: [dir | dir_stack]}

          ["ls" | ls] ->
            %{
              map
              | file_tree:
                  ls
                  |> Enum.reduce(file_tree, fn entry, file_tree ->
                    case String.split(entry) do
                      ["dir", dir] ->
                        put_in(
                          file_tree,
                          [dir | dir_stack] |> Enum.reverse() |> Enum.map(&Access.key(&1, %{})),
                          %{}
                        )

                      [size, filename] ->
                        put_in(
                          file_tree,
                          [filename | dir_stack]
                          |> Enum.reverse()
                          |> Enum.map(&Access.key(&1, %{})),
                          String.to_integer(size)
                        )
                    end
                  end)
            }
        end
      end
    )
    |> Map.get(:file_tree)
  end
end
