defmodule Day17 do
  def part_one(input) do
    <<_::binary-size(byte_size(input)), path::binary>> = part_one_bfs([{{0, 0}, input}])
    path
  end

  def part_two(input) do
    part_two_bfs([{{0, 0}, input}], 0) - String.length(input)
  end

  def available_doors({x, y}) do
    [:up, :down, :left, :right]
    |> Enum.filter(fn
      :up -> y > 0
      :down -> y < 3
      :left -> x > 0
      :right -> x < 3
    end)
  end

  def part_one_bfs([{{3, 3}, path} | _]) do
    path
  end

  def part_one_bfs([{pos, path} | queue]) do
    doors = available_doors(pos) -- closed_doors(path)

    {x, y} = pos

    next =
      Enum.map(doors, fn
        :up -> {{x, y - 1}, path <> "U"}
        :down -> {{x, y + 1}, path <> "D"}
        :left -> {{x - 1, y}, path <> "L"}
        :right -> {{x + 1, y}, path <> "R"}
      end)

    part_one_bfs(queue ++ next)
  end

  def part_two_bfs([], state) do
    state
  end

  def part_two_bfs([{{3, 3}, path} | queue], state) do
    part_two_bfs(queue, max(String.length(path), state))
  end

  def part_two_bfs([{pos, path} | queue], state) do
    doors = available_doors(pos) -- closed_doors(path)

    {x, y} = pos

    next =
      Enum.map(doors, fn
        :up -> {{x, y - 1}, path <> "U"}
        :down -> {{x, y + 1}, path <> "D"}
        :left -> {{x - 1, y}, path <> "L"}
        :right -> {{x + 1, y}, path <> "R"}
      end)

    part_two_bfs(queue ++ next, state)
  end

  def closed_doors(path) do
    <<up, down, left, right, _rest::binary>> = md5(path)

    [:up, :down, :left, :right]
    |> Enum.filter(fn
      :up -> up not in ~c"BCDEF"
      :down -> down not in ~c"BCDEF"
      :left -> left not in ~c"BCDEF"
      :right -> right not in ~c"BCDEF"
    end)
  end

  def md5(binary) when is_binary(binary) do
    :md5 |> :crypto.hash(binary) |> :binary.encode_hex()
  end
end

input = "qtetzkpl"
IO.puts(Day17.part_one(input))
IO.puts(Day17.part_two(input))
