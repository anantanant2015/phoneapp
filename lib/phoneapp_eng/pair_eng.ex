defmodule Phoneapp.PairEng do
  @split_delimiter 3

  alias Phoneapp.EtsCache

  def generate_pairs(number) do
    sliced_number_list = number |> to_string |> slicer() |> merge()
    flatten_sliced_number_list = sliced_number_list |> List.flatten() |> Enum.uniq()

    keyword_list = EtsCache.ets_lookup("number_list") |> List.first() |> elem(1)

    filtered_keyword_list =
      keyword_list
      |> Enum.map(fn {_k, v} ->
        if v["number"] in flatten_sliced_number_list do
          {String.to_atom(v["number"]), v["word"]}
        end
      end)
      |> Enum.reject(fn x -> x == nil end)

    sliced_number_list_with_words =
      sliced_number_list
      |> Enum.map(fn x ->
        x
        |> Enum.map(fn y ->
          values = Keyword.get_values(filtered_keyword_list, String.to_atom(y))

          case values do
            [] ->
              [y]

            _ ->
              values
          end
        end)
      end)

    sliced_number_list_with_words |> make_pairs([])
  end

  def make_pairs([head | tail], accumulator) do
    newlist = (Enum.count(head) - 1) |> reducer([head])
    make_pairs(tail, newlist ++ accumulator)
  end

  def make_pairs([], accumulator) do
    accumulator
  end

  def merge(list, _accumulator \\ []) do
    list
    |> Enum.concat()
    |> Enum.uniq()
  end

  def slicer(str) do
    Enum.map(@split_delimiter..(String.length(str) - @split_delimiter), fn x ->
      slice(:forward, x, str, nil, []) ++ slice(:backward, x, str, nil, [])
    end) ++ [[[str]]]
  end

  defp slice(_strategy, _delimiter, nil, _list, accumulator) do
    accumulator
  end

  defp slice(strategy, delimiter, str, nil, accumulator) do
    slice(strategy, delimiter, str, [], accumulator)
  end

  defp slice(_strategy, _delimiter, nil, nil, accumulator) do
    accumulator
  end

  defp slice(strategy, delimiter, str, list, accumulator) do
    len = String.length(str)

    if delimiter <= len - 3 do
      case strategy do
        :backward ->
          {head, tail} = String.split_at(str, len - delimiter)

          list1 = [[head, tail] ++ list]
          newaccumulator = list1 ++ accumulator
          slice(strategy, delimiter, head, [tail], newaccumulator)

        :forward ->
          {head, tail} = String.split_at(str, delimiter)

          list1 = [list ++ [head, tail]]
          newaccumulator = list1 ++ accumulator
          slice(strategy, delimiter, tail, [head], newaccumulator)
      end
    else
      slice(strategy, delimiter, nil, nil, accumulator)
    end
  end

  defp reducer(_idx = -1, accumulator), do: accumulator

  defp reducer(idx, accumulator) do
    newlist =
      accumulator
      |> Enum.map(fn x ->
        duplicate_by_index(x, idx)
      end)
      |> Enum.concat()

    reducer(idx - 1, newlist)
  end

  defp duplicate_by_index(list, idx) do
    listat = Enum.at(list, idx)

    if check_list?(listat) do
      if Enum.count(listat) >= 0 do
        {popped_list, _} = List.pop_at(list, idx)
        popped_list |> Enum.map(fn x -> List.replace_at(list, idx, x) end)
      end
    else
      [list]
    end
  end

  defp check_list?(data) do
    is_list(data)
  end
end
