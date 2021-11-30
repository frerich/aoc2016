defmodule Day13 do
  require Integer

  @puzzle_input 1364

  def wall?({x, y}) when x < 0 or y < 0 do
    true
  end

  def wall?({x, y}) do
    (x * x + 3 * x + 2 * x * y + y + y * y + @puzzle_input)
    |> Integer.digits(2)
    |> Enum.count(&(&1 == 1))
    |> Integer.is_odd()
  end

  def adjacent({x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  def step(queue, seen) do
    {{:value, {pos, distance}}, queue} = :queue.out(queue)

    next =
      pos
      |> adjacent()
      |> Enum.reject(&wall?/1)
      |> Enum.reject(fn p -> MapSet.member?(seen, p) end)
      |> Enum.map(fn p -> {p, distance + 1} end)

    {next, queue}
  end

  def run(target, queue, seen) do
    {next, queue} = step(queue, seen)

    case Enum.find(next, fn {pos, _distance} -> pos === target end) do
      nil ->
        queue = Enum.reduce(next, queue, &:queue.in/2)
        seen = Enum.reduce(next, seen, fn {p, _distance}, seen -> MapSet.put(seen, p) end)
        run(target, queue, seen)

      {_pos, distance} ->
        distance
    end
  end

  def expand(limit, queue, seen) do
    case :queue.peek(queue) do
      {:value, {_pos, ^limit}} ->
        MapSet.size(seen)

      _ ->
        {next, queue} = step(queue, seen)
        queue = Enum.reduce(next, queue, &:queue.in/2)
        seen = Enum.reduce(next, seen, fn {p, _distance}, seen -> MapSet.put(seen, p) end)
        expand(limit, queue, seen)
    end
  end

  def part_one do
    target_pos = {31, 39}
    queue = :queue.from_list([{{1, 1}, 0}])
    seen = %MapSet{}
    run(target_pos, queue, seen)
  end

  def part_two do
    max_distance = 50
    queue = :queue.from_list([{{1, 1}, 0}])
    seen = %MapSet{}
    expand(max_distance, queue, seen)
  end
end
