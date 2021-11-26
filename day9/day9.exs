ExUnit.start()

defmodule Day9 do
  @run_rx ~r/\((\d+)x(\d+)\)/

  def runs(""), do: []

  def runs("(" <> _rest = s) do
    [run, rest] = Regex.split(@run_rx, s, include_captures: true, parts: 2, trim: true)

    [run_length, repetitions] = Regex.run(@run_rx, run, capture: :all_but_first)
    {run_length, ""} = Integer.parse(run_length)
    {repetitions, ""} = Integer.parse(repetitions)

    {run, rest} = String.split_at(rest, run_length)

    [{repetitions, run} | runs(rest)]
  end

  def runs(<<char::bytes-size(1)>> <> rest) do
    [{1, char} | runs(rest)]
  end

  def decompressed_length(s) do
    s
    |> runs()
    |> Enum.map(fn {repetitions, run} -> repetitions * String.length(run) end)
    |> Enum.sum()
  end

  def part_one do
    File.read!("input.txt")
    |> String.trim()
    |> decompressed_length()
  end

  def decompressed_length_recursive(<<_::bytes-size(1)>>), do: 1

  def decompressed_length_recursive(s) do
    s
    |> runs()
    |> Enum.map(fn {repetitions, run} -> repetitions * decompressed_length_recursive(run) end)
    |> Enum.sum()
  end

  def part_two do
    File.read!("input.txt")
    |> String.trim()
    |> decompressed_length_recursive()
  end

  use ExUnit.Case

  def test do
    assert 6 == Day9.decompressed_length("ADVENT")
    assert 7 == Day9.decompressed_length("A(1x5)BC")
    assert 9 == Day9.decompressed_length("(3x3)XYZ")
    assert 11 == Day9.decompressed_length("A(2x2)BCD(2x2)EFG")
    assert 6 == Day9.decompressed_length("(6x1)(1x3)A")
    assert 18 == Day9.decompressed_length("X(8x2)(3x3)ABCY")

    assert 9 == Day9.decompressed_length_recursive("(3x3)XYZ")
    assert 20 == Day9.decompressed_length_recursive("X(8x2)(3x3)ABCY")
    assert 241920 == Day9.decompressed_length_recursive("(27x12)(20x12)(13x14)(7x10)(1x12)A")
    assert 445 == Day9.decompressed_length_recursive("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
  end
end

Day9.test()
IO.puts(Day9.part_one())
IO.puts(Day9.part_two())
