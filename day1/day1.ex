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
  defp collect_digits(<<"one", rest::binary>>, acc), do: collect_digits("e" <> rest, [49 | acc])
  defp collect_digits(<<"two", rest::binary>>, acc), do: collect_digits("o" <> rest, [50 | acc])
  defp collect_digits(<<"three", rest::binary>>, acc), do: collect_digits("e" <> rest, [51 | acc])
  defp collect_digits(<<"four", rest::binary>>, acc), do: collect_digits("r" <> rest, [52 | acc])
  defp collect_digits(<<"five", rest::binary>>, acc), do: collect_digits("e" <> rest, [53 | acc])
  defp collect_digits(<<"six", rest::binary>>, acc), do: collect_digits("x" <> rest, [54 | acc])
  defp collect_digits(<<"seven", rest::binary>>, acc), do: collect_digits("n" <> rest, [55 | acc])
  defp collect_digits(<<"eight", rest::binary>>, acc), do: collect_digits("t" <> rest, [56 | acc])
  defp collect_digits(<<"nine", rest::binary>>, acc), do: collect_digits("e" <> rest, [57 | acc])

  defp collect_digits(<<char::utf8, rest::binary>>, acc) when is_digit(char) do
    collect_digits(rest, [char | acc])
  end

  defp collect_digits(<<char::utf8>>, acc) when is_digit(char) do
    collect_digits(<<>>, [char | acc])
  end

  defp collect_digits(<<_, rest::binary>>, acc), do: collect_digits(rest, acc)
  defp collect_digits(<<>>, acc), do: Enum.reverse(acc)

  defp build_calibration_number([number]) do
    String.to_integer(<<number>> <> <<number>>)
  end

  defp build_calibration_number([head | rest]) do
    last = List.last(rest)
    String.to_integer(<<head>> <> <<last>>)
  end
end

Day1.solve()
|> IO.inspect()
