Mix.install([
  {:benchee, "~> 1.0", only: :dev}
])

defmodule Day02.Part1 do
  def solve do
    games = File.read!("input.txt") |> String.split("\n", trim: true)

    for game <- games, id = game_id(game), not is_nil(id), reduce: 0 do
      acc -> acc + id
    end
  end

  defp game_id("Game " <> rest) do
    {id, ": " <> game} = Integer.parse(rest)
    bags = String.split(game, "; ")

    game_possible? =
      Enum.all?(bags, fn bag ->
        bag
        |> String.split(", ")
        |> Enum.reduce(%{}, &count_colors_in_set/2)
        |> valid_set?()
      end)

    if game_possible? do
      id
    end
  end

  defp count_colors_in_set(color, acc) do
    {total, " " <> color} = Integer.parse(color)
    update_in(acc, [Access.key(color, 0)], &(&1 + total))
  end

  defp valid_set?(game_results) do
    under_threshold?(game_results["red"], 12) and
      under_threshold?(game_results["green"], 13) and
      under_threshold?(game_results["blue"], 14)
  end

  defp under_threshold?(nil, _threshold), do: true
  defp under_threshold?(value, threshold), do: value <= threshold
end

defmodule Day02.Part2 do
  def solve do
    games = File.read!("input.txt") |> String.split("\n", trim: true)

    for game <- games, power = cubes_power(game), not is_nil(power), reduce: 0 do
      acc -> acc + power
    end
  end

  defp cubes_power("Game " <> rest) do
    {_id, ": " <> game} = Integer.parse(rest)
    rolls = String.split(game, ["; ", ", "], trim: true)
    result = Enum.reduce(rolls, %{}, &count_colors_in_set/2)
    result["green"] * result["blue"] * result["red"]
  end

  defp count_colors_in_set(color, acc) do
    {total, " " <> color} = Integer.parse(color)
    update_in(acc, [Access.key(color, 0)], &max(&1, total))
  end
end

Benchee.run(%{
  "day_2_part1" => fn ->
    Day02.Part1.solve()
  end,
  "day_2_part2" => fn ->
    Day02.Part2.solve()
  end
})
