defmodule PhoneappWeb.PageController do
  use PhoneappWeb, :controller

  alias Phoneapp.{Dictionary, Repo}

  @split_delimiter 3

  def index(conn, _params) do
    start = DateTime.utc_now()
    t1 = slicer("6686787825") |> merge
    t2 = Repo.one(Dictionary)
    t3 = t1 |> List.flatten |> Enum.uniq
    t4 = t2.object |> Enum.map(fn {_k, v} -> 
      if (v["number"] in t3) do
        {String.to_atom(v["number"]), v["word"]}
      end
     end) |> Enum.reject(fn x -> x==nil end)
    

    t5 = t1 |> Enum.map(fn x ->  
          x |> Enum.map(fn y ->  
              values = Keyword.get_values(t4, String.to_atom(y))
              case values do
                [] ->
                  [y]

                _ ->
                  values
              end
            end)
      end)

    t6 = t5 |> make_pairs([])
    IO.inspect(t6)


    finish = DateTime.utc_now()
    DateTime.diff(start, finish, :millisecond) |> IO.inspect()


    
    render(conn, "index.html")
  end

  def make_pairs([head | tail], accumulator) do
    newlist = (Enum.count(head)-1) |> reducer([head])
    make_pairs(tail, newlist ++ accumulator)
  end

  def make_pairs([], accumulator) do
    accumulator
  end

  def reducer(idx = -1, accumulator), do: accumulator

  def reducer(idx, accumulator) do
    newlist = accumulator |> Enum.map(
      fn x ->
        duplicate_by_index(x, idx)
      end
    ) |> Enum.concat
    reducer(idx - 1, newlist)
  end

  def duplicate_by_index(list, idx) do
    listat = Enum.at(list, idx)
    if check_list?(listat) do
      if (Enum.count(listat) >= 0) do
        {popped_list, newlist} = List.pop_at(list, idx)
        popped_list |> Enum.map(fn x -> List.replace_at(list, idx, x) end)
      end
    else
      [list]
    end
  end

  def check_list?(data) do
    is_list(data)
  end

  def check_exclusion?(data) do
    !(String.contains?(data, "0") || String.contains?(data, "1"))
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

  def slice(_strategy, _delimiter, nil, _list, accumulator) do
    accumulator
  end

  def slice(strategy, delimiter, str, nil, accumulator) do
    slice(strategy, delimiter, str, [], accumulator)
  end

  def slice(_strategy, _delimiter, nil, nil, accumulator) do
    accumulator
  end

  def slice(strategy, delimiter, str, list, accumulator) do
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
end
