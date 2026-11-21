defmodule ShoddyBotWeb.PageController do
  use ShoddyBotWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
