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
    # [1] -> [1]
    # [1,2] -> [1] -> [1]
    # [1,2,3] -> [3,1] -> [3]
    # [1,2,3,4] -> [2,4,1] -> [1,2] -> [1]
    # [1,2,3,4,5] -> [2,4,5,1] -> [4,1,2] -> [2,4] -> [2]
    # [1,2,3,4,5,6] -> [2,3,5,6,1] -> [3,6,1,2] -> [6,2,3] -> [3,6] -> [3]
    IO.puts(take(Enum.to_list(1..6), 6))
  end

  def step([elf]), do: elf

  def step(elves) do
    if rem(Enum.count(elves), 2) == 0 do
      step(Enum.take_every(elves, 2))
    else
      step(Enum.take_every(Enum.drop(elves, 2), 2))
    end
  end

  def take([elf] = elves, _count) do
    dbg(elves)
    elf
  end

  def take(elves, count) do
    dbg(elves)
    [elf | elves] = List.delete_at(elves, div(count, 2))
    take(elves ++ [elf], count - 1)
  end
end

Day19.part_one()
#Day19.part_two()

