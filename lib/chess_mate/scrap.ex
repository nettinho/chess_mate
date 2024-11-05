defmodule ChessMate.Scrap do
  @base_url "https://info64.org"

  def fetch_tournment(tournment) do
    document =
      "#{@base_url}/team/#{tournment}"
      |> Req.get!()
      |> Map.get(:body)
      |> Floki.parse_document!()

    rate =
      document
      |> Floki.find(".rateofplay")
      |> Floki.text()
      |> String.trim()

    name =
      document
      |> Floki.find("h1")
      |> Floki.text()

    date =
      document
      |> Floki.find("#dates")
      |> Floki.text()
      |> String.trim()

    teams =
      document
      |> Floki.find("tbody")
      |> case do
        [{"tbody", _, table}] -> table
        _ -> []
      end
      |> Enum.map(&parse_team_row/1)

    {%{code: tournment, name: name, when: date, rate: rate}, teams}
  end

  def fetch_teams_standings(tournment_code) do
    "#{@base_url}/team/#{tournment_code}/standings"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("tbody")
    |> case do
      [{"tbody", _, table} | _] -> table
      _ -> []
    end
    |> Enum.into(%{}, &parse_team_standing_row/1)
  end

  def fetch_team(tournment_code, team_code) do
    "#{@base_url}/team/#{tournment_code}/#{team_code}"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("tbody")
    |> case do
      [{"tbody", _, table} | _] -> table
      _ -> []
    end
    |> Enum.map(&parse_player_row/1)
  end

  def fetch_schedule(tournment_code) do
    "#{@base_url}/team/#{tournment_code}/schedule"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("table")
    |> case do
      [{"table", _, table} | _] -> table
      _ -> []
    end
    |> Enum.map(&parse_schedule_row/1)
  end

  def fetch_games(tournment_code, round) do
    "#{@base_url}/team/#{tournment_code}/board/#{round}"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("tbody")
    |> case do
      [{"tbody", _, table} | _] -> table
      _ -> []
    end
    |> Enum.reduce({[], nil}, &reduce_game_row/2)
    |> elem(0)
  end

  def fetch_player_details(fide_id) do
    "https://ratings.fide.com/profile/#{fide_id}"
    |> Req.get!()
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find(".profile-top-info__block__row__data")
    |> then(fn [_, country, _, birth_year, gender | _] ->
      %{
        country: Floki.text(country),
        birth_year:
          birth_year
          |> Floki.text()
          |> Integer.parse()
          |> case do
            {birth_year, ""} -> birth_year
            :error -> 0
          end,
        gender: Floki.text(gender)
      }
    end)
  end

  defp parse_team_row(row) do
    row
    |> Floki.find(".teamname")
    |> case do
      [
        {"td", _,
         [
           {"a",
            [
              {"href", link}
            ], [name]}
         ]}
      ] ->
        code = link |> String.split("/") |> Enum.at(3)
        %{name: String.trim(name), code: code}
    end
  end

  defp parse_team_standing_row(
         {"tr", _, [current_rank, initial_rank, link, _, points, _, average_elo | _]}
       ) do
    initial_rank =
      initial_rank
      |> Floki.text()
      |> String.trim()
      |> String.to_integer()

    current_rank =
      current_rank
      |> Floki.text()
      |> String.trim()
      |> String.to_integer()

    points =
      points
      |> Floki.text()
      |> String.trim()
      |> String.to_float()

    average_elo =
      average_elo
      |> Floki.text()
      |> String.trim()
      |> Integer.parse()
      |> case do
        {elo, ""} -> elo
        :error -> 0
      end

    code =
      link
      |> case do
        {_, _, [{_, [{_, link}], _}]} ->
          code =
            link
            |> String.split("/")
            |> Enum.at(3)

          code
      end

    {code,
     %{
       initial_rank: initial_rank,
       current_rank: current_rank,
       points: points,
       average_elo: average_elo
     }}
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

  defp parse_schedule_row(row) do
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

    {:ok, timestamp, _} =
      row
      |> Floki.find("td")
      |> case do
        [{"td", _, [{_, _, [date]}, time]}] ->
          "#{date}T#{String.trim(time)}:00Z"

        _ ->
          nil
      end
      |> DateTime.from_iso8601()

    %{
      round: round,
      timestamp: timestamp
    }
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
      "- - -" -> "draw"
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
end
