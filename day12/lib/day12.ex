defmodule Day12 do
  def program do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn instr -> String.split(instr) end)
  end

  def part_one do
    %{"a" => 0, "b" => 0, "c" => 0, "d" => 0, :ip => 0, code: program()}
    |> run()
    |> Map.get("a")
  end

  def part_two do
    %{"a" => 0, "b" => 0, "c" => 1, "d" => 0, :ip => 0, code: program()}
    |> run()
    |> Map.get("a")
  end

  def run(machine) do
    machine
    |> Stream.iterate(&eval/1)
    |> Stream.drop_while(fn m -> m.ip < Enum.count(m.code) end)
    |> Enum.at(0)
  end

  def eval(machine) do
    case Enum.at(machine.code, machine.ip) do
      ["inc", reg] ->
        machine
        |> Map.update!(reg, &(&1 + 1))
        |> Map.update!(:ip, &(&1 + 1))

      ["dec", reg] ->
        machine
        |> Map.update!(reg, &(&1 - 1))
        |> Map.update!(:ip, &(&1 + 1))

      ["cpy", val, reg] ->
        val =
          case Integer.parse(val) do
            {val, ""} ->
              val

            :error ->
              Map.get(machine, val)
          end

        machine
        |> Map.put(reg, val)
        |> Map.update!(:ip, &(&1 + 1))

      ["jnz", reg, offset] ->
        {offset, ""} = Integer.parse(offset)

        case Map.get(machine, reg) do
          0 ->
            Map.update!(machine, :ip, &(&1 + 1))

          _ ->
            Map.update!(machine, :ip, &(&1 + offset))
        end

      nil ->
        nil
    end
  end
end
