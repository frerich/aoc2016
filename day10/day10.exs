defmodule Day10 do
  defmodule Bot do
    defstruct [:high_value_output, :lower_value_output, holding: []]
  end

  def instructions do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def initialize do
    state =
      instructions()
      |> Enum.reduce(%{}, fn instruction, state ->
        case String.split(instruction) do
          ["bot", bot_no, "gives", "low", "to", "bot", low_out, "and", "high", "to", "bot", high_out] ->
            {bot_no, ""} = Integer.parse(bot_no)
            {high_out, ""} = Integer.parse(high_out)
            {low_out, ""} = Integer.parse(low_out)

            state
            |> Map.put_new({:bot, bot_no}, %Bot{})
            |> Map.update!({:bot, bot_no}, fn bot -> %{bot | high_value_output: {:bot, high_out}, lower_value_output: {:bot, low_out}} end)

          ["bot", bot_no, "gives", "low", "to", "output", low_out, "and", "high", "to", "bot", high_out] ->
            {bot_no, ""} = Integer.parse(bot_no)
            {high_out, ""} = Integer.parse(high_out)
            {low_out, ""} = Integer.parse(low_out)

            state
            |> Map.put_new({:bot, bot_no}, %Bot{})
            |> Map.update!({:bot, bot_no}, fn bot -> %{bot | high_value_output: {:bot, high_out}, lower_value_output: {:output, low_out}} end)

          ["bot", bot_no, "gives", "low", "to", "bot", low_out, "and", "high", "to", "output", high_out] ->
            {bot_no, ""} = Integer.parse(bot_no)
            {high_out, ""} = Integer.parse(high_out)
            {low_out, ""} = Integer.parse(low_out)

            state
            |> Map.put_new({:bot, bot_no}, %Bot{})
            |> Map.update!({:bot, bot_no}, fn bot -> %{bot | high_value_output: {:output, high_out}, lower_value_output: {:bot, low_out}} end)

          ["bot", bot_no, "gives", "low", "to", "output", low_out, "and", "high", "to", "output", high_out] ->
            {bot_no, ""} = Integer.parse(bot_no)
            {high_out, ""} = Integer.parse(high_out)
            {low_out, ""} = Integer.parse(low_out)

            state
            |> Map.put_new({:bot, bot_no}, %Bot{})
            |> Map.update!({:bot, bot_no}, fn bot -> %{bot | high_value_output: {:output, high_out}, lower_value_output: {:output, low_out}} end)

          ["value", value, "goes", "to", "bot", bot_no] ->
            {value, ""} = Integer.parse(value)
            {bot_no, ""} = Integer.parse(bot_no)

            state
            |> Map.put_new({:bot, bot_no}, %Bot{})
            |> Map.update!({:bot, bot_no}, fn %Bot{holding: holding} = bot -> %{bot | holding: [value | holding]} end)

          _ ->
            IO.puts("Unhandled instruction '#{instruction}'")
            state
        end
      end)
    state
  end

  def step(state) do
    case Enum.find(state, fn
      {_id, %Bot{holding: holding}} -> Enum.count(holding) == 2
      _ -> false
    end) do
      {active_bot_id, active_bot} ->

        {lower_value, higher_value} = Enum.min_max(active_bot.holding)

        if lower_value == 17 and higher_value == 61 do
          IO.inspect(active_bot_id)
        end

        state =
          case active_bot.high_value_output do
            {:bot, bot_no} ->
              Map.update!(state, {:bot, bot_no}, fn %Bot{holding: holding} = bot -> %{bot | holding: [higher_value | holding]} end)

            {:output, output_no} ->
              Map.put(state, {:output, output_no}, higher_value)
          end

        state =
          case active_bot.lower_value_output do
            {:bot, bot_no} ->
              Map.update!(state, {:bot, bot_no}, fn %Bot{holding: holding} = bot -> %{bot | holding: [lower_value | holding]} end)

            {:output, output_no} ->
              Map.put(state, {:output, output_no}, lower_value)
          end

        state =
          Map.update!(state, active_bot_id, fn bot -> %{bot | holding: []} end)

        {:cont, state}

      nil ->
        {:halt, state}
    end
  end

  def run(state) do
    case step(state) do
      {:cont, state} -> run(state)
      {:halt, state} -> state
    end
  end
end
