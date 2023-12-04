Mix.install([
  {:benchee, "~> 1.0", only: :dev}
])

defmodule Day04.Part1 do
  def solve do
    "input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_game_points/1)
    |> Enum.sum()
  end

  defp calculate_game_points("Card" <> rest) do
    {_card_number, ": " <> rest} = Integer.parse(String.trim(rest))
    [numbers, winning_numbers] = String.split(rest, " | ")

    winning_numbers =
      winning_numbers
      |> String.split(" ", trim: true)
      |> MapSet.new()

    numbers = String.split(numbers, " ", trim: true)

    total_matching_numbers =
      Enum.reduce(numbers, 0, fn number, acc ->
        if MapSet.member?(winning_numbers, number) do
          acc + 1
        else
          acc
        end
      end)

    case total_matching_numbers do
      0 -> 0
      other -> 2 ** (other - 1)
    end
  end
end

defmodule Day04.Part2 do
  def solve do
    cards =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&calculate_card/1)

    cards_lookup =
      Enum.reduce(cards, %{}, fn {card_number, total_matching_numbers}, acc ->
        Map.put(acc, card_number, {card_number, total_matching_numbers})
      end)

    count_cards(cards, cards_lookup, 0)
  end

  defp count_cards([{id, 0} | rest], cards_lookup, count) do
    count_cards(rest, cards_lookup, count + 1)
  end

  defp count_cards([{id, total_matching_numbers} | rest], cards_lookup, count) do
    next_cards = next_n_cards(id, total_matching_numbers, cards_lookup)
    count_cards(next_cards ++ rest, cards_lookup, count + 1)
  end

  defp count_cards([], _cards_lookup, count), do: count

  defp next_n_cards(actual_card, n, cards_lookup) do
    (actual_card + 1)..(actual_card + n)
    |> Enum.map(&Map.get(cards_lookup, &1))
    |> Enum.reject(&is_nil/1)
  end

  defp calculate_card("Card" <> rest) do
    {card_number, ": " <> rest} = Integer.parse(String.trim(rest))
    [numbers, winning_numbers] = String.split(rest, " | ")

    winning_numbers =
      winning_numbers
      |> String.split(" ", trim: true)
      |> MapSet.new()

    numbers = String.split(numbers, " ", trim: true)

    total_matching_numbers =
      Enum.reduce(numbers, 0, fn number, acc ->
        if MapSet.member?(winning_numbers, number) do
          acc + 1
        else
          acc
        end
      end)

    {card_number, total_matching_numbers}
  end
end

Benchee.run(%{
  "day_4_part1" => fn ->
    Day04.Part1.solve()
  end,
  "day_4_part2" => fn ->
    Day04.Part2.solve()
  end
})
