defmodule Day18 do
  def part_one(input) do
    input
    |> Stream.iterate(&next_row/1)
    |> Stream.map(fn row -> Enum.count(row, & &1 == ?.) end)
    |> Enum.take(40)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Stream.iterate(&next_row/1)
    |> Stream.map(fn row -> Enum.count(row, & &1 == ?.) end)
    |> Enum.take(400_000)
    |> Enum.sum()
  end

  def next_row(row) do
    ~c".#{row}."
    |> Enum.chunk_every(3, 1)
    |> Enum.drop(-1)
    |> Enum.map(fn
      ~c"^^." -> ?^
      ~c".^^" -> ?^
      ~c"^.." -> ?^
      ~c"..^" -> ?^
      _ -> ?.
    end)
  end
end

input = ~c".^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^."
IO.puts(Day18.part_one(input))
IO.puts(Day18.part_two(input))

