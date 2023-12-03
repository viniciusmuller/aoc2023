Mix.install([
  {:benchee, "~> 1.0", only: :dev}
])

defmodule Day03.Part1 do
  defguard is_digit(char) when char in 49..57

  def solve do
    lines = File.read!("input.txt") |> String.split("\n", trim: true)

    {numbers, symbols} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({[], MapSet.new()}, fn {line, y_position}, acc ->
        count_digits(line, 0, y_position, acc)
      end)

    for {number, {x, y, length}} <- numbers,
        part_number?(x, y, length, symbols),
        reduce: 0 do
      acc -> acc + number
    end
  end

  def count_digits(
        <<char::utf8, _rest::binary>> = input,
        x_position,
        y_position,
        {numbers, symbols}
      )
      when is_digit(char) do
    {number, rest} = Integer.parse(input)
    length = get_total_digits(number, 1)
    updated_numbers = [{number, {x_position, y_position, length}} | numbers]
    count_digits(rest, x_position + length, y_position, {updated_numbers, symbols})
  end

  def count_digits(<<".", rest::binary>>, x_position, y_position, acc) do
    count_digits(rest, x_position + 1, y_position, acc)
  end

  def count_digits(<<_symbol::utf8, rest::binary>>, x_position, y_position, {numbers, symbols}) do
    updated_symbols = MapSet.put(symbols, {x_position, y_position})
    count_digits(rest, x_position + 1, y_position, {numbers, updated_symbols})
  end

  def count_digits(<<>>, _, _, acc), do: acc

  def get_total_digits(number, digits) when number >= 10 do
    get_total_digits(number / 10, digits + 1)
  end

  def get_total_digits(_, digits), do: digits

  defp part_number?(x, y, length, symbols) do
    horizontal_range = (x - 1)..(x + length)

    Enum.any?(horizontal_range, fn test_x_value ->
      MapSet.member?(symbols, {test_x_value, y - 1}) or
        MapSet.member?(symbols, {test_x_value, y + 1})
    end) or
      MapSet.member?(symbols, {x - 1, y}) or
      MapSet.member?(symbols, {x + length, y})
  end
end

defmodule Day03.Part2 do
  defguard is_digit(char) when char in 49..57

  def solve do
    lines = File.read!("input.txt") |> String.split("\n", trim: true)

    {gears, numbers} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), %{}}, fn {line, y_position}, acc ->
        track_numbers_and_gears(line, 0, y_position, acc)
      end)

    gears_neighbors = track_gears_neighbors(gears, numbers)

    for {_position, [n1, n2]} <- gears_neighbors, reduce: 0 do
      acc -> acc + n1 * n2
    end
  end

  def track_numbers_and_gears(
        <<char::utf8, _rest::binary>> = input,
        x_position,
        y_position,
        {gears, numbers}
      )
      when is_digit(char) do
    {number, rest} = Integer.parse(input)
    length = get_total_digits(number, 1)
    updated_numbers = Map.put(numbers, {x_position, y_position}, number)
    track_numbers_and_gears(rest, x_position + length, y_position, {gears, updated_numbers})
  end

  def track_numbers_and_gears(<<"*", rest::binary>>, x_position, y_position, {gears, numbers}) do
    updated_gears = MapSet.put(gears, {x_position, y_position})
    track_numbers_and_gears(rest, x_position + 1, y_position, {updated_gears, numbers})
  end

  def track_numbers_and_gears(<<_other::utf8, rest::binary>>, x_position, y_position, acc) do
    track_numbers_and_gears(rest, x_position + 1, y_position, acc)
  end

  def track_numbers_and_gears(<<>>, _, _, acc), do: acc

  def get_total_digits(number, digits) when number >= 10 do
    get_total_digits(number / 10, digits + 1)
  end

  def get_total_digits(_, digits), do: digits

  defp track_gears_neighbors(gears, numbers) do
    Enum.reduce(numbers, %{}, fn {{x, y}, number}, acc ->
      length = get_total_digits(number, 1)

      (x - 1)..(x + length)
      |> Enum.reduce(acc, fn test_x_value, acc ->
        acc
        |> track_neighbor_at_position(gears, {test_x_value, y - 1}, number)
        |> track_neighbor_at_position(gears, {test_x_value, y + 1}, number)
      end)
      |> track_neighbor_at_position(gears, {x - 1, y}, number)
      |> track_neighbor_at_position(gears, {x + length, y}, number)
    end)
  end

  defp track_neighbor_at_position(neighbor_count, gears, position, number) do
    if MapSet.member?(gears, position) do
      Map.update(neighbor_count, position, [number], &[number | &1])
    else
      neighbor_count
    end
  end
end

Benchee.run(%{
  "day_3_part1" => fn ->
    Day03.Part1.solve()
  end,
  "day_3_part2" => fn ->
    Day03.Part2.solve()
  end
})
