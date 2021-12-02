defmodule Day16 do
  require Integer

  @doc ~S"""
  Performs a data generation step.

  ## Examples:

      iex> Day16.step([1])
      [1,0,0]

      iex> Day16.step([0])
      [0,0,1]

      iex> Day16.step([1,1,1,1,1])
      [1,1,1,1,1,0,0,0,0,0,0]

      iex> Day16.step([1,1,1,1,0,0,0,0,1,0,1,0])
      [1,1,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,1,1,1,1,0,0,0,0]
  """
  def step(a) do
    b = Enum.map(Enum.reverse(a), fn
      0 -> 1
      1 -> 0
    end)

    a ++ [0] ++ b
  end

  @doc ~S"""
  Compute checksum of data.

  ## Examples:

      iex> Day16.checksum([1,1,0,0,1,0,1,1,0,1,0,0])
      [1,0,0]
  """
  def checksum(data) do
    digest = Enum.map(Enum.chunk_every(data, 2), fn
      [x,x] -> 1
      _ -> 0
    end)

    if Integer.is_even(Enum.count(digest)) do
      checksum(digest)
    else
      digest
    end
  end

  @doc ~S"""
  Generates data to fill up a harddisk. Returns the final checksum.

  ## Examples:

  iex> Day16.generate([1,0,0,0,0], 20)
  [0,1,1,0,0]
  """
  def generate(state, length) do
    state
    |> Stream.iterate(&step/1)
    |> Stream.drop_while(fn data -> Enum.count(data) < length end)
    |> Enum.at(0)
    |> Enum.take(length)
    |> checksum()
  end

  def part_one() do
    generate([1,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0], 272)
  end

  def part_two() do
    generate([1,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0], 35651584)
  end
end
