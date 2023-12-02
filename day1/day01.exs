Mix.install([
  {:benchee, "~> 1.0", only: :dev}
])

defmodule Day1 do
  defguard is_digit(char) when char in 49..57

  def solve do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> Enum.map(&collect_digits(&1, []))
    |> Enum.map(&build_calibration_number/1)
    |> Enum.sum()
  end

  # Comment/Uncomment these clauses for toggling part 1/2
  defp collect_digits(<<"one", rest::binary>>, acc), do: collect_digits("e" <> rest, [1 | acc])
  defp collect_digits(<<"two", rest::binary>>, acc), do: collect_digits("o" <> rest, [2 | acc])
  defp collect_digits(<<"three", rest::binary>>, acc), do: collect_digits("e" <> rest, [3 | acc])
  defp collect_digits(<<"four", rest::binary>>, acc), do: collect_digits("r" <> rest, [4 | acc])
  defp collect_digits(<<"five", rest::binary>>, acc), do: collect_digits("e" <> rest, [5 | acc])
  defp collect_digits(<<"six", rest::binary>>, acc), do: collect_digits("x" <> rest, [6 | acc])
  defp collect_digits(<<"seven", rest::binary>>, acc), do: collect_digits("n" <> rest, [7 | acc])
  defp collect_digits(<<"eight", rest::binary>>, acc), do: collect_digits("t" <> rest, [8 | acc])
  defp collect_digits(<<"nine", rest::binary>>, acc), do: collect_digits("e" <> rest, [9 | acc])

  defp collect_digits(<<char::utf8, rest::binary>>, acc) when is_digit(char) do
    collect_digits(rest, [char - 48 | acc])
  end

  defp collect_digits(<<char::utf8>>, acc) when is_digit(char) do
    collect_digits(<<>>, [char - 48 | acc])
  end

  defp collect_digits(<<_, rest::binary>>, acc), do: collect_digits(rest, acc)
  defp collect_digits(<<>>, acc), do: Enum.reverse(acc)

  defp build_calibration_number([number]) do
    number * 10 + number
  end

  defp build_calibration_number([head | rest]) do
    last = List.last(rest)
    head * 10 + last
  end
end

Benchee.run(
  %{"day_1" => fn ->
    result = Day1.solve()

    if result != 54418 do
      raise "wrong answer"
    end
  end}
)

