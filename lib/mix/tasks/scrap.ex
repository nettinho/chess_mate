defmodule Mix.Tasks.Scrap do
  use Mix.Task

  @base_url "https://info64.org"
  def run(_args) do
    Mix.Task.run("app.start")
    # IO.inspect(args, label: "args")

    # tournment = "campeonato-de-ajedrez-rapido-por-equipos-de-madrid-2024-2025"

    "#{@base_url}/team/campeonato-de-ajedrez-rapido-por-equipos-de-madrid-2024-2025/board/9"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("tbody")
    |> case do
      [{"tbody", _, table} | _] -> table
      _ -> []
    end
    |> Enum.reduce({[], nil}, &reduce_game_row/2)

    # "#{@base_url}/team/campeonato-de-ajedrez-rapido-por-equipos-de-madrid-2024-2025/colmenar-viejo-c"
    # |> Req.get!()iex
    # |> Map.get(:body)
    # |> Floki.parse_document!()
    # |> Floki.find("tbody")
    # |> case do
    #   [{"tbody", _, table} | _] -> table
    #   _ -> []
    # end
    # |> Enum.map(&parse_player_row/1)
    # |> dbg
  end

  defp reduce_game_row(
         {_, [{"class", "board-pairing"}],
          [
            table,
            {_, _, [{_, [{"href", link_local}], _}]},
            _,
            _,
            _,
            result,
            {_, _, [{_, [{_, link_visitor}], _}]},
            _,
            _,
            _
          ]},
         {acc, team_table}
       ) do
    local = parse_code(link_local)
    visitor = parse_code(link_visitor)

    game = %{
      local: local,
      visitor: visitor,
      result: parse_result(result),
      table: parse_table(table),
      team_table: team_table
    }

    {[game | acc], team_table}
  end

  defp reduce_game_row(
         {_, [{"class", "board-pairing"}],
          [
            table,
            {_, _, [{_, [{"href", link_local}], _}]},
            _,
            _,
            _,
            result,
            _
          ]},
         {acc, team_table}
       ) do
    local = parse_code(link_local)

    game = %{
      local: local,
      visitor: nil,
      result: parse_result(result),
      table: parse_table(table),
      team_table: team_table
    }

    {[game | acc], team_table}
  end

  defp reduce_game_row(
         {_, [{"class", "board-pairing"}],
          [
            table,
            _,
            result,
            {_, _, [{_, [{_, link_visitor}], _}]},
            _,
            _,
            _
          ]},
         {acc, team_table}
       ) do
    visitor = parse_code(link_visitor)

    game = %{
      local: nil,
      visitor: visitor,
      result: parse_result(result),
      table: parse_table(table),
      team_table: team_table
    }

    {[game | acc], team_table}
  end

  defp reduce_game_row({_, [{"class", "team-pairing"}], [table | _]}, {acc, _}) do
    team_table = parse_table(table)
    {acc, team_table}
  end

  defp parse_result(result) do
    result
    |> Floki.text()
    |> String.trim()
    |> case do
      "1 - 0" -> "local"
      "0 - 1" -> "visitor"
      "0.5 - 0.5" -> "draw"
      "+ - -" -> "local"
      "- - +" -> "visitor"
      "-" -> nil
    end
  end

  defp parse_table(table) do
    table
    |> Floki.text()
    |> String.trim()
    |> String.to_integer()
  end

  defp parse_code(link) do
    [_, _, _, team, code] = String.split(link, "/")
    {team, code}
  end

  def parse_schedule_row(row) do
    round =
      row
      |> Floki.find("a")
      |> case do
        [{"a", [{"href", link}], _}] -> link
        _ -> nil
      end
      |> String.split("/")
      |> Enum.at(3)
      |> String.to_integer()

    timestamp =
      row
      |> Floki.find("td")
      |> case do
        [{"td", _, [{_, _, [date]}, time]}] ->
          "#{date}T#{String.trim(time)}:00"

        _ ->
          nil
      end

    %{
      round: round,
      timestamp: NaiveDateTime.from_iso8601!(timestamp)
    }
  end

  defp parse_player_row(row) do
    board_number =
      row
      |> Floki.find(".playerstartrank")
      |> Floki.text()
      |> String.trim()
      |> String.to_integer()

    {name, code} =
      row
      |> Floki.find(".playername")
      |> case do
        [{_, _, [{_, [{_, link}], [name]}]}] ->
          code =
            link
            |> String.split("/")
            |> Enum.at(4)

          {String.trim(name), code}
      end

    fide =
      row
      |> Floki.find(".playerfideratid")
      |> Floki.text()
      |> String.trim()

    elo =
      row
      |> Floki.find(".playerfiderat")
      |> Floki.text()
      |> String.trim()
      |> String.to_integer()

    title =
      row
      |> Floki.find(".playertitle")
      |> Floki.text()
      |> String.trim()

    %{
      board_number: board_number,
      elo: elo,
      title: title,
      name: name,
      fide: fide,
      code: code
    }
  end
end
