defmodule Day7 do
  def input, do: File.read!("input.txt") |> String.split() |> Enum.map(&parse_address/1)

  def parse_address(addr) do
    parts =
      addr
      |> String.split(~r/\[|\]/)
      |> Enum.map(&String.to_charlist/1)

    network_identifiers = Stream.cycle([:supernet, :hypernet])

    Enum.zip(network_identifiers, parts)
  end

  def contains_abba?(s) do
    s
    |> windows(4)
    |> Enum.any?(fn
      [a, b, b, a] when a != b -> true
      _ -> false
    end)
  end

  def supports_tls?(ipv7) do
    sections = Enum.group_by(ipv7, &elem(&1, 0), &elem(&1, 1))

    abba_in_hypernet? = Enum.any?(sections[:hypernet], &contains_abba?/1)
    abba_in_supernet? = Enum.any?(sections[:supernet], &contains_abba?/1)

    abba_in_supernet? and not abba_in_hypernet?
  end

  def supports_ssl?(ipv7) do
    sections = Enum.group_by(ipv7, &elem(&1, 0), &elem(&1, 1))

    all_abas =
      sections[:supernet]
      |> Enum.flat_map(fn supernet ->
        supernet
        |> windows(3)
        |> Enum.filter(fn
          [a, b, a] when a != b -> true
          _ -> false
        end)
        |> Enum.to_list()
      end)

    all_abas
    |> Enum.any?(fn [a, b, a] ->
      Enum.any?(sections[:hypernet], fn hypernet ->
        sublist?([b, a, b], hypernet)
      end)
    end)
  end

  def part_one, do: count_if(input(), &supports_tls?/1)

  def part_two, do: count_if(input(), &supports_ssl?/1)

  def windows(enum, len),
    do: Stream.chunk_every(enum, len, 1, :discard)

  def count_if(enum, fun),
    do: enum |> Stream.filter(fun) |> Enum.count()

  def sublist?(a, b),
    do: b |> windows(Enum.count(a)) |> Enum.any?(&(a == &1))
end

IO.puts(Day7.part_one())
IO.puts(Day7.part_two())
