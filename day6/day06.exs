defmodule Day06 do
  def part_1 do
    [["Time:" | time], ["Distance:" | distance]] =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    time = Enum.map(time, &String.to_integer/1)
    distance = Enum.map(distance, &String.to_integer/1)

    time
    |> Enum.zip(distance)
    |> Enum.map(&calculate_time/1)
    |> Enum.product()
  end

  def part_2 do
    [["Time:" | time], ["Distance:" | distance]] =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    time = Enum.join(time) |> String.to_integer()
    distance = Enum.join(distance) |> String.to_integer()

    calculate_time({time, distance})
  end

  defp calculate_time({time, distance}) do
    1..time
    |> Enum.map(&calculate_race(&1, time))
    |> Enum.filter(& &1 > distance)
    |> Enum.count()
  end

  defp calculate_race(time_awaited, total_time) do
    speed = time_awaited
    (total_time - time_awaited) * speed
  end
end

Day06.part_1()
|> IO.inspect()

Day06.part_2()
|> IO.inspect()
