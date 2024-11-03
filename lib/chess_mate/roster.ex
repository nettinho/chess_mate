defmodule ChessMate.Roster do
  @moduledoc """
  The Roster context.
  """

  import Ecto.Query, warn: false
  alias ChessMate.Playbook.TeamRound
  alias ChessMate.Repo

  alias ChessMate.Roster.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def put_player(%{fide: fide} = attrs) do
    Player
    |> Repo.get_by(fide: fide)
    |> case do
      nil ->
        %Player{}
        |> Player.changeset(attrs)
        |> Repo.insert()

      player ->
        player
        |> Player.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  alias ChessMate.Roster.Tournment

  @doc """
  Returns the list of tournments.

  ## Examples

      iex> list_tournments()
      [%Tournment{}, ...]

  """
  def list_tournments do
    Repo.all(Tournment)
  end

  @doc """
  Gets a single tournment.

  Raises `Ecto.NoResultsError` if the Tournment does not exist.

  ## Examples

      iex> get_tournment!(123)
      %Tournment{}

      iex> get_tournment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournment!(id),
    do:
      Tournment
      |> preload([:teams, :rounds])
      |> Repo.get!(id)

  @doc """
  Creates a tournment.

  ## Examples

      iex> create_tournment(%{field: value})
      {:ok, %Tournment{}}

      iex> create_tournment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournment(attrs \\ %{}) do
    %Tournment{}
    |> Tournment.changeset(attrs)
    |> Repo.insert()
  end

  def put_tournment(%{code: code} = attrs) do
    Tournment
    |> Repo.get_by(code: code)
    |> case do
      nil ->
        %Tournment{}
        |> Tournment.changeset(attrs)
        |> Repo.insert()

      tournment ->
        tournment
        |> Tournment.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a tournment.

  ## Examples

      iex> update_tournment(tournment, %{field: new_value})
      {:ok, %Tournment{}}

      iex> update_tournment(tournment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournment(%Tournment{} = tournment, attrs) do
    tournment
    |> Tournment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournment.

  ## Examples

      iex> delete_tournment(tournment)
      {:ok, %Tournment{}}

      iex> delete_tournment(tournment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournment(%Tournment{} = tournment) do
    Repo.delete(tournment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournment changes.

  ## Examples

      iex> change_tournment(tournment)
      %Ecto.Changeset{data: %Tournment{}}

  """
  def change_tournment(%Tournment{} = tournment, attrs \\ %{}) do
    Tournment.changeset(tournment, attrs)
  end

  alias ChessMate.Roster.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  def list_teams_by_prefixes(prefixes) do
    prefixes
    |> Enum.reduce(Team, &or_where(&2, [t], ilike(t.name, ^"#{&1}%")))
    |> Repo.all()
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    Team
    |> preload(^preload)
    |> Repo.get!(id)
  end

  def get_team_by(attrs, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    Team
    |> preload(^preload)
    |> Repo.get_by(attrs)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def put_team(%{code: code} = attrs) do
    Team
    |> Repo.get_by(code: code)
    |> case do
      nil ->
        %Team{}
        |> Team.changeset(attrs)
        |> Repo.insert()

      team ->
        team
        |> Team.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias ChessMate.Roster.PlayerTeam

  @doc """
  Returns the list of players_teams.

  ## Examples

      iex> list_players_teams()
      [%PlayerTeam{}, ...]

  """
  def list_players_teams do
    Repo.all(PlayerTeam)
  end

  @doc """
  Gets a single player_team.

  Raises `Ecto.NoResultsError` if the Player team does not exist.

  ## Examples

      iex> get_player_team!(123)
      %PlayerTeam{}

      iex> get_player_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_team!(id, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    PlayerTeam
    |> preload(^preload)
    |> Repo.get!(id)
  end

  def get_player_team_by(attrs), do: Repo.get_by(PlayerTeam, attrs)

  @doc """
  Creates a player_team.

  ## Examples

      iex> create_player_team(%{field: value})
      {:ok, %PlayerTeam{}}

      iex> create_player_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_team(attrs \\ %{}) do
    %PlayerTeam{}
    |> PlayerTeam.changeset(attrs)
    |> Repo.insert()
  end

  def put_player_team(%{player_id: player_id, team_id: team_id} = attrs) do
    PlayerTeam
    |> Repo.get_by(player_id: player_id, team_id: team_id)
    |> case do
      nil ->
        %PlayerTeam{}
        |> PlayerTeam.changeset(attrs)
        |> Repo.insert()

      player ->
        player
        |> PlayerTeam.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a player_team.

  ## Examples

      iex> update_player_team(player_team, %{field: new_value})
      {:ok, %PlayerTeam{}}

      iex> update_player_team(player_team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_team(%PlayerTeam{} = player_team, attrs) do
    player_team
    |> PlayerTeam.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_team.

  ## Examples

      iex> delete_player_team(player_team)
      {:ok, %PlayerTeam{}}

      iex> delete_player_team(player_team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_team(%PlayerTeam{} = player_team) do
    Repo.delete(player_team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_team changes.

  ## Examples

      iex> change_player_team(player_team)
      %Ecto.Changeset{data: %PlayerTeam{}}

  """
  def change_player_team(%PlayerTeam{} = player_team, attrs \\ %{}) do
    PlayerTeam.changeset(player_team, attrs)
  end

  alias ChessMate.Roster.Round

  @doc """
  Returns the list of rounds.

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id), do: Repo.get!(Round, id)

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  def put_round(%{tournment_id: tournment_id, round: round} = attrs) do
    Round
    |> Repo.get_by(tournment_id: tournment_id, round: round)
    |> case do
      nil ->
        %Round{}
        |> Round.changeset(attrs)
        |> Repo.insert()

      round ->
        round
        |> Round.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{data: %Round{}}

  """
  def change_round(%Round{} = round, attrs \\ %{}) do
    Round.changeset(round, attrs)
  end

  alias ChessMate.Roster.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  def put_game(%{round_id: round_id, team_table: team_table, table: table} = attrs) do
    Game
    |> Repo.get_by(round_id: round_id, team_table: team_table, table: table)
    |> case do
      nil ->
        %Game{}
        |> Game.changeset(attrs)
        |> Repo.insert()

      game ->
        game
        |> Game.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def get_next_round_tournments(prefixes) do
    now = DateTime.utc_now()

    future_rounds =
      from r in Round,
        where: r.timestamp > ^now,
        select: %{
          id: r.id,
          rn: over(row_number(), partition_by: r.tournment_id, order_by: r.timestamp)
        }

    next_rounds =
      from(r in Round,
        join: fut in subquery(future_rounds),
        on: fut.id == r.id and fut.rn == 1,
        select: r
      )

    teams = Enum.reduce(prefixes, Team, &or_where(&2, [t], ilike(t.name, ^"#{&1}%")))

    from(t in Tournment,
      join: r in subquery(next_rounds),
      on: r.tournment_id == t.id,
      select: %{t | next_round: r}
    )
    |> preload(teams: ^teams)
    |> Repo.all()
  end

  def get_next_round_tournments_with_round(prefixes) do
    now = DateTime.utc_now()

    future_rounds =
      from r in Round,
        where: r.timestamp > ^now,
        select: %{
          id: r.id,
          rn: over(row_number(), partition_by: r.tournment_id, order_by: r.timestamp)
        }

    next_rounds =
      from(r in Round,
        join: fut in subquery(future_rounds),
        on: fut.id == r.id and fut.rn == 1,
        select: r
      )

    teams_query = Enum.reduce(prefixes, Team, &or_where(&2, [t], ilike(t.name, ^"#{&1}%")))

    team_rounds_query = ChessMate.Playbook.team_round_with_opponent_query()

    from(t in Tournment,
      join: r in subquery(next_rounds),
      on: r.tournment_id == t.id,
      select: %{t | next_round: r},
      left_join: teams in subquery(teams_query),
      on: teams.tournment_id == t.id,
      left_join: team_rounds in subquery(team_rounds_query),
      on: team_rounds.round_id == r.id and team_rounds.team_id == teams.id,
      preload: [
        teams: {teams, next_round: {team_rounds, [players: [team_player: [:player]]]}}
      ]
    )
    |> Repo.all()
  end

  defp parse_player(%{id: id, player: %{name: name}, elo: elo, title: title}),
    do: %{id: id, name: name, elo: elo, title: title}

  defp parse_player(_), do: %{name: nil, elo: nil, title: nil}

  defp player_team(%{team: %{name: team_name, id: id}}), do: {id, team_name}
  defp player_team(_), do: nil

  defp result_to_win(_, "draw"), do: "draw"
  defp result_to_win(win, win), do: "win"
  defp result_to_win(_, nil), do: nil
  defp result_to_win(_, _), do: "lose"

  def parse_game_as_local(%{
        table: table,
        round: round,
        result: result,
        local: local,
        visitor: visitor
      }),
      do: %{
        table: table,
        round: round,
        team_player: parse_player(local),
        opponent_player: parse_player(visitor),
        opponent_team: player_team(visitor),
        win: result_to_win("local", result)
      }

  def parse_game_as_visitor(%{
        table: table,
        round: round,
        result: result,
        local: local,
        visitor: visitor
      }),
      do: %{
        table: table,
        round: round,
        team_player: parse_player(visitor),
        opponent_player: parse_player(local),
        opponent_team: player_team(local),
        win: result_to_win("visitor", result)
      }
end
