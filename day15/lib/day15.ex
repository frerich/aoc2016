defmodule Day15 do
  def input do
    "input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      words = line |> String.trim_trailing(".") |> String.split()

      ["Disc", _x, "has", n, "positions;", "at", "time=0,", "it", "is", "at", "position", p] =
        words

      {String.to_integer(n), String.to_integer(p)}
    end)
  end

  def zero_positions({layer, positions, offset}) do
    Stream.iterate(positions - offset - layer, &(&1 + positions))
  end

  def zero_position?(t, {layer, positions, offset}) do
    rem(offset + t + layer, positions) == 0
  end

  def button_moment(discs) do
    [largest_disc | rest] = 
      discs
      |> Enum.with_index(fn {positions, offset}, index -> {index + 1, positions, offset} end)
      |> Enum.sort_by(fn {_layer, positions, _offset} -> positions end, :desc)

    largest_disc
    zero_positions(largest_disc)
    |> Stream.filter(fn t ->
      Enum.all?(rest, fn disc -> zero_position?(t, disc) end)
    end)
    |> Enum.at(0)
  end

  def part_one, do: button_moment(input())
  def part_two, do: button_moment(input() ++ [{11, 0}])
end
