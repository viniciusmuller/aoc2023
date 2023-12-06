Mix.install([
  {:benchee, "~> 1.0", only: :dev}
])

defmodule Day05 do
  def part_1 do
    sliced_input =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    {seeds, rest} = parse_seeds(sliced_input)
    almanac_raw = parse_almanac_entries(rest, {nil, [], %{}})

    for seed <- seeds do
      soil = find_in_almanac(almanac_raw, :seed_to_soil, seed)
      fertilizer = find_in_almanac(almanac_raw, :soil_to_fertilizer, soil)
      water = find_in_almanac(almanac_raw, :fertilizer_to_water, fertilizer)
      light = find_in_almanac(almanac_raw, :water_to_light, water)
      temperature = find_in_almanac(almanac_raw, :light_to_temperature, light)
      humidity = find_in_almanac(almanac_raw, :temperature_to_humidity, temperature)
      find_in_almanac(almanac_raw, :humidity_to_location, humidity)
    end
    |> Enum.min()
  end

  def part_2() do
    sliced_input =
      "example.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    {seeds, rest} = parse_seeds(sliced_input)
    almanac_raw = parse_almanac_entries(rest, {nil, [], %{}})
    seed_pairs = Enum.chunk_every(seeds, 2)

    IO.inspect(seed_pairs)
    # TODO: part 2 (and cleanup parsed structure)
  end

  defp find_in_almanac(almanac, entry, number) do
    result = Enum.find(almanac[entry], fn {_destination, source, length} ->
      number in source..(source + length)
    end)

    case result do
      nil -> number
      {destination, source, _length} ->
        diff = destination - source
        number + diff
    end
  end

  defp parse_seeds(["seeds: " <> seeds | rest]) do
    seeds
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> then(&{&1, rest})
  end

  @maps [
    {"seed-to-soil map:", :seed_to_soil},
    {"soil-to-fertilizer map:", :soil_to_fertilizer},
    {"fertilizer-to-water map:", :fertilizer_to_water},
    {"water-to-light map:", :water_to_light},
    {"light-to-temperature map:", :light_to_temperature},
    {"temperature-to-humidity map:", :temperature_to_humidity},
    {"humidity-to-location map:", :humidity_to_location}
  ]

  for {pattern, result_key} <- @maps do
    defp parse_almanac_entries(
           [unquote(pattern) | rest],
           {current_section, current_items, result}
         ) do
       acc = case current_section do
         nil -> {unquote(result_key), [], result}
         _ -> {unquote(result_key), [], Map.put(result, current_section, Enum.reverse(current_items))}
       end
      parse_almanac_entries(rest, acc)
    end
  end

  defp parse_almanac_entries(
         [numbers | rest],
         {current_section, current_items, result}
       ) do
    [destination_start, source_start, length] = String.split(numbers, " ") |> Enum.map(&String.to_integer/1)
    updated_numbers = [{destination_start, source_start, length} | current_items]
    parse_almanac_entries(rest, {current_section, updated_numbers, result})
  end

  defp parse_almanac_entries(
         [],
         {current_section, current_items, result}
       ) do
     Map.put(result, current_section, Enum.reverse(current_items))
  end
end

Benchee.run(%{
  "day_5_part1" => fn ->
    Day05.part_1()
  end,
  "day_5_part2" => fn ->
    Day05.part_2()
  end
})
