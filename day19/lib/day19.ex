defmodule Day19 do
  def part_one do
    # [1] -> [1]
    # [1,2] -> [1]
    # [1,2,3] -> [3]
    # [1,2,3,4] -> [1,3] -> [1]
    # [1,2,3,4,5] -> [3,5] -> [3]
    # [1,2,3,4,5,6] -> [1,3,5] -> [5]
    # [1,2,3,4,5,6,7] -> [3,5,7] -> [7]
    # [1,2,3,4,5,6,7,8] -> [1,3,5,7] -> [1,5] -> [1]
    #
    IO.puts(step(1..3004953))
  end

  def part_two do
    # All group sizes of elves in which elf #1 gets all the presents.
    lengths_with_winner_1 = Stream.iterate(2, fn x -> x * 3 - 2 end)

    # Largest group size which is lower than the puzzle input
    start = Enum.take_while(lengths_with_winner_1, & &1 < 3004953) |> List.last()

    IO.puts(3004953 - start + 1)
  end

  def step([elf]), do: elf

  def step(elves) do
    if rem(Enum.count(elves), 2) == 0 do
      step(Enum.take_every(elves, 2))
    else
      step(Enum.take_every(Enum.drop(elves, 2), 2))
    end
  end
end

Day19.part_one()
Day19.part_two()

