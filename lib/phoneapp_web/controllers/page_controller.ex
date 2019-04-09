defmodule PhoneappWeb.PageController do
  use PhoneappWeb, :controller

  alias Phoneapp.PairEng

  def index(conn, _params) do
    start = DateTime.utc_now()

    PairEng.generate_pairs(6_686_787_825) |> IO.inspect()
    finish = DateTime.utc_now()
    DateTime.diff(start, finish, :millisecond) |> IO.inspect()

    render(conn, "index.html")
  end
end
