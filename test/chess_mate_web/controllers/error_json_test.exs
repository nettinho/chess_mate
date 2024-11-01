defmodule ChessMateWeb.ErrorJSONTest do
  use ChessMateWeb.ConnCase, async: true

  test "renders 404" do
    assert ChessMateWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ChessMateWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
