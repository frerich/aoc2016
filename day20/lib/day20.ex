defmodule Day20 do
  def input do
    input = File.read!("input.txt")

    for line <- String.split(input) do
      [from, to] = String.split(line, "-")
      String.to_integer(from)..String.to_integer(to)
    end
  end

  def part_one do
    blocked_ranges = input()

    blocked_ranges
    |> Enum.flat_map(fn from..to//_ -> [from - 1, to + 1] end)
    |> Enum.sort()
    |> Enum.filter(fn addr -> addr >= 0 end)
    |> Enum.find(fn addr -> not Enum.any?(blocked_ranges, fn range -> addr in range end) end)
    |> IO.puts()
  end

  def part_two do
    total_ips = 4294967296

    blocked_ips =
      input()
      |> Enum.sort_by(fn from.._to//_ -> from end)
      |> Enum.reduce([], fn
        range, [] -> [range]
        r0..r1//_, [c0..c1//_ | ranges] when r0 <= c1 -> [c0..max(r1,c1) | ranges]
        range, [cur | ranges] -> [range, cur | ranges]
      end)
      |> Enum.sum_by(&Enum.count/1)

    IO.puts(total_ips - blocked_ips)
  end
end

Day20.part_one()
Day20.part_two()
