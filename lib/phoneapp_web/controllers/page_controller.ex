defmodule PhoneappWeb.PageController do
  use PhoneappWeb, :controller

  alias Phoneapp.PairEng

  def index(conn, _params) do
    render(conn, "index.html", number_list: [], time: 0)
  end

  def show(conn, params) do
    start = DateTime.utc_now()

    number_list =
      case String.length(params["number"]) > 0 do
        true ->
          params["number"] |> String.to_integer() |> PairEng.generate_pairs()

        _ ->
          [[]]
      end

    finish = DateTime.utc_now()
    time = DateTime.diff(finish, start, :millisecond)
    count = Enum.count(number_list)
    render(conn, "index.html", number_list: number_list, time: time, count: count)
  end
end
