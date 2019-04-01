defmodule PhoneappWeb.PageController do
  use PhoneappWeb, :controller

  alias Phoneapp.{Dictionary, Repo}

  @split_delimiter 3

  def index(conn, _params) do
    start = DateTime.utc_now()
    t1 = slicer("6895256989") |> merge
    finish = DateTime.utc_now()
    DateTime.diff(start, finish, :millisecond) |> IO.inspect()
    t2 = Repo.one(Dictionary)
    render(conn, "index.html")
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

  def slicable(len) do
    if len >= 5 do
      true
    else
      false
    end
  end
end
