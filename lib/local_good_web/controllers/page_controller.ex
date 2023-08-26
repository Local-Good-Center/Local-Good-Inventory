defmodule LocalGoodWeb.PageController do
  use LocalGoodWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: ~p</app>)
  end
end
