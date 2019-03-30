defmodule PhoneappWeb.PageController do
  use PhoneappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
