defmodule Day8 do
  @screen_width 50
  @screen_height 6

  @rect_rx ~r/(rect) (\d+)x(\d+)/
  @rotate_row_rx ~r/(rotate row) y=(\d+) by (\d+)/
  @rotate_column_rx ~r/(rotate column) x=(\d+) by (\d+)/

  def input do
    File.read!("input.txt") |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end

  def turn_on(screen, width, height) do
    pixels = for y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y}

    MapSet.union(screen, MapSet.new(pixels))
  end

  def rotate_column(screen, column, distance) do
    screen
    |> Enum.map(fn
      {^column, y} -> {column, rem(y + distance, @screen_height)}
      other -> other
    end)
    |> MapSet.new()
  end

  def rotate_row(screen, row, distance) do
    screen
    |> Enum.map(fn
      {x, ^row} -> {rem(x + distance, @screen_width), row}
      other -> other
    end)
    |> MapSet.new()
  end

  def render(screen) do
    for y <- 0..(@screen_height - 1) do
      for x <- 0..(@screen_width - 1) do
        if MapSet.member?(screen, {x, y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end

      IO.write("\n")
    end
  end

  def eval(command, screen) do
    parse_result =
      Regex.run(@rect_rx, command, capture: :all_but_first) ||
        Regex.run(@rotate_row_rx, command, capture: :all_but_first) ||
        Regex.run(@rotate_column_rx, command, capture: :all_but_first)

    case parse_result do
      ["rect", width, height] ->
        {width, ""} = Integer.parse(width)
        {height, ""} = Integer.parse(height)
        turn_on(screen, width, height)

      ["rotate row", row, distance] ->
        {row, ""} = Integer.parse(row)
        {distance, ""} = Integer.parse(distance)
        rotate_row(screen, row, distance)

      ["rotate column", column, distance] ->
        {column, ""} = Integer.parse(column)
        {distance, ""} = Integer.parse(distance)
        rotate_column(screen, column, distance)
    end
  end

  def part_one do
    input()
    |> Enum.reduce(%MapSet{}, &eval/2)
    |> MapSet.size()
  end

  def part_two do
    input()
    |> Enum.reduce(%MapSet{}, &eval/2)
    |> render()
  end
end

IO.puts(Day8.part_one())
Day8.part_two()
