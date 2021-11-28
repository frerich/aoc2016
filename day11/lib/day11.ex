defmodule Day11 do
  @example_materials [:hydrogen, :lithium]
  @puzzle_materials_one [:strontium, :plutonium, :thulium, :ruthenium, :curium]
  @puzzle_materials_two [
    :strontium,
    :plutonium,
    :thulium,
    :ruthenium,
    :curium,
    :dilithium,
    :elerium
  ]

  @top_floor 4

  @materials @puzzle_materials_one

  @items Enum.flat_map(@materials, &[{:generator, &1}, {:microchip, &1}])

  def final_state?(%{} = state) do
    Enum.all?(@items, fn item -> Map.get(state, item) == @top_floor end)
  end

  def any_microchip_fried?(state) do
    Enum.any?(@materials, fn material ->
      microchip_floor = state[{:microchip, material}]

      microchip_shielded? = microchip_floor == state[{:generator, material}]

      other_generator_on_same_floor? =
        Enum.any?(@materials, fn other_mat ->
          other_mat != material and state[{:generator, other_mat}] == microchip_floor
        end)

      other_generator_on_same_floor? and not microchip_shielded?
    end)
  end

  def legal_state?(%{} = state) do
    not any_microchip_fried?(state)
  end

  def move_cargo(state, cargo, offset) do
    Enum.reduce([:elevator | cargo], state, fn item, state ->
      Map.update!(state, item, &(&1 + offset))
    end)
  end

  def next_states(%{} = state) do
    items_on_same_floor = Enum.filter(@items, &(Map.get(state, &1) == state.elevator))

    single_items = for item <- items_on_same_floor, do: [item]

    item_pairs =
      for [item_a | rest] <- tails(items_on_same_floor), item_b <- rest, do: [item_a, item_b]

    all_cargo = single_items ++ item_pairs

    case state.elevator do
      1 ->
        Enum.map(all_cargo, fn cargo -> move_cargo(state, cargo, 1) end)

      4 ->
        Enum.map(all_cargo, fn cargo -> move_cargo(state, cargo, -1) end)

      _ ->
        Enum.map(all_cargo, fn cargo -> move_cargo(state, cargo, 1) end) ++
          Enum.map(all_cargo, fn cargo -> move_cargo(state, cargo, -1) end)
    end
  end

  def go(queue, seen) do
    {{:value, {state, distance}}, queue} = :queue.out(queue)

    next =
      state
      |> next_states()
      |> Enum.reject(fn state -> MapSet.member?(seen, state) end)
      |> Enum.filter(&legal_state?/1)

    case Enum.find(next, &final_state?/1) do
      nil ->
        queue = Enum.reduce(next, queue, fn state, queue -> :queue.in({state, distance + 1}, queue) end)
        seen = MapSet.union(seen, MapSet.new(next))
        go(queue, seen)

      _state ->
        distance + 1
    end
  end

  def run(initial_state) do
    queue = :queue.new()
    queue = :queue.in({initial_state, 0}, queue)
    seen = MapSet.new([initial_state])

    go(queue, seen)
  end

  def example do
    %{
      :elevator => 1,
      {:generator, :hydrogen} => 2,
      {:microchip, :hydrogen} => 1,
      {:generator, :lithium} => 3,
      {:microchip, :lithium} => 1
    }
    |> run()
  end

  def part_one do
    %{
      :elevator => 1,
      {:generator, :strontium} => 1,
      {:microchip, :strontium} => 1,
      {:generator, :plutonium} => 1,
      {:microchip, :plutonium} => 1,
      {:generator, :thulium} => 2,
      {:generator, :ruthenium} => 2,
      {:microchip, :ruthenium} => 2,
      {:generator, :curium} => 2,
      {:microchip, :curium} => 2,
      {:microchip, :thulium} => 3
    }
    |> run()
  end

  def part_two do
    %{
      :elevator => 1,
      {:generator, :strontium} => 1,
      {:microchip, :strontium} => 1,
      {:generator, :plutonium} => 1,
      {:microchip, :plutonium} => 1,
      {:generator, :dilithium} => 1,
      {:microchip, :dilithium} => 1,
      {:generator, :elerium} => 1,
      {:microchip, :elerium} => 1,
      {:generator, :thulium} => 2,
      {:generator, :ruthenium} => 2,
      {:microchip, :ruthenium} => 2,
      {:generator, :curium} => 2,
      {:microchip, :curium} => 2,
      {:microchip, :thulium} => 3
    }
    |> run()
  end

  def tails([]), do: []
  def tails([_ | tail] = list), do: [list | tails(tail)]
end
