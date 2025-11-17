defmodule Day21 do
  def part_one do
    operations = File.read!("input.txt") |> String.split("\n", trim: true)

    Enum.reduce(operations, ~c"abcdefgh", &step/2)
  end

  def part_two do
    operations = File.read!("input.txt") |> String.split("\n", trim: true)

    Enum.reduce(Enum.reverse(operations), ~c"fbgdceah", &reverse/2)
  end

  def reverse("rotate left 1 step", password) do
    reverse("rotate left 1 steps", password)
  end

  def reverse(<<"rotate left ", x::integer, " steps">>, password) do
    x = x - ?0
    step("rotate right #{x} steps", password)
  end

  def reverse("rotate right 1 step", password) do
    reverse("rotate right 1 steps", password)
  end

  def reverse(<<"rotate right ", x::integer, " steps">>, password) do
    x = x - ?0
    step("rotate left #{x} steps", password)
  end

  def reverse(<<"move position ", x::integer, " to position ", y::integer>>, password) do
    x = x - ?0
    y = y - ?0
    step("move position #{y} to position #{x}", password)
  end

  def reverse(<<"rotate based on position of letter ", x::integer>>, password) do
    Enum.find_value(0..length(password), fn delta ->
      rot_left = step("rotate left #{delta} steps", password)
      if step("rotate based on position of letter #{<<x>>}", rot_left) == password do
        rot_left
      end
    end)
  end

  def reverse(operation, password) do
    step(operation, password)
  end

  def step(<<"swap position ", x::integer, " with position ", y::integer>>, password) do
    x = x - ?0
    y = y - ?0

    ch1 = Enum.at(password, x)
    ch2 = Enum.at(password, y)
    password |> List.replace_at(x, ch2) |> List.replace_at(y, ch1)
  end

  def step(<<"swap letter ", x::integer, " with letter ", y::integer>>, password) do
    Enum.map(password, fn
      ^x -> y
      ^y -> x
      x -> x
    end)
  end

  def step("rotate left 1 step", password) do
    step("rotate left 1 steps", password)
  end

  def step(<<"rotate left ", x::integer, " steps">>, password) do
    x = x - ?0
    {front, back} = Enum.split(password, rem(x, length(password)))
    back ++ front
  end

  def step("rotate right 1 step", password) do
    step("rotate right 1 steps", password)
  end

  def step(<<"rotate right ", x::integer, " steps">>, password) do
    x = x - ?0
    {front, back} = Enum.split(password, -rem(x, length(password)))
    back ++ front
  end

  def step(<<"rotate based on position of letter ", x::integer>>, password) do
    index = Enum.find_index(password, & &1 == x)
    if index < 4 do
      step("rotate right #{index + 1} steps", password)
    else
      step("rotate right #{index + 2} steps", password)
    end
  end

  def step(<<"reverse positions ", x::integer, " through ", y::integer>>, password) do
    x = x - ?0
    y = y - ?0
    {front, rest} = Enum.split(password, x)
    {middle, back} = Enum.split(rest, y - x + 1)
    front ++ Enum.reverse(middle) ++ back
  end

  def step(<<"move position ", x::integer, " to position ", y::integer>>, password) do
    x = x - ?0
    y = y - ?0
    {ch, password} = List.pop_at(password, x)
    List.insert_at(password, y, ch)
  end
end

can_reverse = fn operation, password ->
  Day21.reverse(operation, Day21.step(operation, password)) == password
end

true = Day21.step("swap position 4 with position 0", ~c"abcde") == ~c"ebcda"
true = Day21.step("swap letter d with letter b", ~c"ebcda") == ~c"edcba"
true = Day21.step("reverse positions 0 through 4", ~c"edcba") == ~c"abcde"
true = Day21.step("rotate left 1 step", ~c"abcde") == ~c"bcdea"
true = Day21.step("move position 1 to position 4", ~c"bcdea") == ~c"bdeac"
true = Day21.step("move position 3 to position 0", ~c"bdeac") == ~c"abdec"
true = Day21.step("rotate based on position of letter b", ~c"abdec") == ~c"ecabd"
true = Day21.step("rotate based on position of letter d", ~c"ecabd") == ~c"decab"

true = can_reverse.("swap position 4 with position 0", ~c"abcde")
true = can_reverse.("swap letter d with letter b", ~c"ebcda")
true = can_reverse.("reverse positions 0 through 4", ~c"edcba")
true = can_reverse.("rotate left 1 step", ~c"abcde")
true = can_reverse.("rotate left 2 steps", ~c"abcde")
true = can_reverse.("move position 1 to position 4", ~c"bcdea")
true = can_reverse.("move position 3 to position 0", ~c"bdeac")
true = can_reverse.("rotate based on position of letter b", ~c"abcdefgh")
true = can_reverse.("rotate based on position of letter d", ~c"abcedfgh")

IO.puts(Day21.part_one())
IO.puts(Day21.part_two())
