defmodule Day14 do
  import ExProf.Macro

  @salt "zpqevtbw"
  # @salt "abc"

  def md5(s) do
    :md5
    |> :crypto.hash(s)
    |> Base.encode16(case: :lower)
  end

  def windows(enum, len) do
    enum
    |> Stream.chunk_every(len, 1, :discard)
    |> Enum.to_list()
  end

  def triplet(s) do
    s
    |> String.to_charlist()
    |> windows(3)
    |> Enum.find(fn x -> match?([a, a, a], x) end)
  end

  def quintet(s) do
    s
    |> String.to_charlist()
    |> windows(5)
    |> Enum.find(fn x -> match?([a, a, a, a, a], x) end)
  end

  def hash_index(i) do
    md5("#{@salt}#{i}")
  end

  def stretched_hash(i) do
    case :ets.lookup(:stretched_hash_cache, i) do
      [{^i, hash}] ->
        hash

      [] ->
        hash =
          hash_index(i)
          |> Stream.iterate(&md5/1)
          |> Stream.take(2017)
          |> Enum.at(-1)

        :ets.insert(:stretched_hash_cache, {i, hash})

        hash
    end
  end

  def valid_keys_for(i, hashfun) do
    case quintet(hashfun.(i)) do
      [a, a, a, a, a] ->
        start = max(0, i - 1000)

        Enum.flat_map(start..(i - 1), fn j ->
          case triplet(hashfun.(j)) do
            [^a, ^a, ^a] ->
              [j]

            _ ->
              []
          end
        end)

      _ ->
        []
    end
  end

  def part_one do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.flat_map(fn index -> valid_keys_for(index, &hash_index/1) end)
    |> Stream.uniq()
    |> Enum.take(64)
    |> Enum.sort()
    |> Enum.at(-1)
  end

  def part_two do
    if :stretched_hash_cache in :ets.all, do: :ets.delete(:stretched_hash_cache)
    :ets.new(:stretched_hash_cache, [:named_table])

    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.flat_map(fn index -> valid_keys_for(index, &stretched_hash/1) end)
    |> Stream.uniq()
    |> Enum.take(64)
    |> Enum.sort()
    |> Enum.at(-1)
  end
end
