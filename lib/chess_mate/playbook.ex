defmodule ChessMate.Playbook do
  @moduledoc """
  The Playbook context.
  """

  import Ecto.Query, warn: false
  alias ChessMate.Repo

  alias ChessMate.Playbook.TeamRound

  defp then_preload({:ok, schema}, preload), do: {:ok, Repo.preload(schema, preload)}
  defp then_preload(error, _), do: error

  defp on_ok({:ok, value}, fun), do: {:ok, fun.(value)}
  defp on_ok(error, _), do: error

  @doc """
  Returns the list of team_round.

  ## Examples

      iex> list_team_round()
      [%TeamRound{}, ...]

  """
  def list_team_round do
    Repo.all(TeamRound)
  end

  @doc """
  Gets a single team_round.

  Raises `Ecto.NoResultsError` if the Team round does not exist.

  ## Examples

      iex> get_team_round!(123)
      %TeamRound{}

      iex> get_team_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_round!(id, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    TeamRound
    |> preload(^preload)
    |> Repo.get!(id)
  end

  @doc """
  Creates a team_round.

  ## Examples

      iex> create_team_round(%{field: value})
      {:ok, %TeamRound{}}

      iex> create_team_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_round(attrs \\ %{}) do
    %TeamRound{}
    |> TeamRound.changeset(attrs)
    |> Repo.insert()
  end

  def put_team_round(%{round_id: round_id, team_id: team_id} = attrs, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])
    with_opponent = Keyword.get(opts, :with_opponent, false)

    TeamRound
    |> Repo.get_by(round_id: round_id, team_id: team_id)
    |> case do
      nil ->
        %TeamRound{}
        |> TeamRound.changeset(attrs)
        |> Repo.insert()

      team_round ->
        team_round
        |> TeamRound.changeset(attrs)
        |> Repo.update()
    end
    |> maybe_enrich_opponent(with_opponent)
    |> then_preload(preload)
  end

  defp maybe_enrich_opponent(data, true), do: on_ok(data, &enrich_opponent/1)
  defp maybe_enrich_opponent(data, _), do: data

  @doc """
  Updates a team_round.

  ## Examples

      iex> update_team_round(team_round, %{field: new_value})
      {:ok, %TeamRound{}}

      iex> update_team_round(team_round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_round(%TeamRound{} = team_round, attrs, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    team_round
    |> TeamRound.changeset(attrs)
    |> Repo.update()
    |> then_preload(preload)
  end

  @doc """
  Deletes a team_round.

  ## Examples

      iex> delete_team_round(team_round)
      {:ok, %TeamRound{}}

      iex> delete_team_round(team_round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_round(%TeamRound{} = team_round) do
    Repo.delete(team_round)
  end

  def team_round_with_opponent_query do
    from tr in TeamRound,
      join: r in assoc(tr, :round),
      join: g in assoc(r, :games),
      join: local_pt in assoc(g, :local),
      join: local_team in assoc(local_pt, :team),
      join: visitor_pt in assoc(g, :visitor),
      join: visitor_team in assoc(visitor_pt, :team),
      where: local_team.id == tr.team_id or visitor_team.id == tr.team_id,
      select: %{
        tr
        | opponent_team:
            fragment(
              "CASE WHEN ? = ? THEN ? ELSE ? END",
              local_team.id,
              tr.team_id,
              visitor_team.name,
              local_team.name
            ),
          opponent_team_id:
            fragment(
              "CASE WHEN ? = ? THEN ? ELSE ? END",
              local_team.id,
              tr.team_id,
              visitor_team.id,
              local_team.id
            )
      },
      distinct: tr.id
  end

  def enrich_opponent(%TeamRound{} = team_round) do
    team_round_with_opponent_query()
    |> where([tr], tr.id == ^team_round.id)
    |> Repo.one()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_round changes.

  ## Examples

      iex> change_team_round(team_round)
      %Ecto.Changeset{data: %TeamRound{}}

  """
  def change_team_round(%TeamRound{} = team_round, attrs \\ %{}) do
    TeamRound.changeset(team_round, attrs)
  end

  alias ChessMate.Playbook.PlayerAvailability

  @doc """
  Returns the list of player_availability.

  ## Examples

      iex> list_player_availability()
      [%PlayerAvailability{}, ...]

  """
  def list_player_availability do
    Repo.all(PlayerAvailability)
  end

  @doc """
  Gets a single player_availability.

  Raises `Ecto.NoResultsError` if the Player availability does not exist.

  ## Examples

      iex> get_player_availability!(123)
      %PlayerAvailability{}

      iex> get_player_availability!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_availability!(id), do: Repo.get!(PlayerAvailability, id)

  @doc """
  Creates a player_availability.

  ## Examples

      iex> create_player_availability(%{field: value})
      {:ok, %PlayerAvailability{}}

      iex> create_player_availability(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_availability(attrs \\ %{}) do
    %PlayerAvailability{}
    |> PlayerAvailability.changeset(attrs)
    |> Repo.insert()
  end

  def put_player_availability(
        %{team_round_id: team_round_id, team_player_id: team_player_id} = attrs,
        opts \\ []
      ) do
    preload = Keyword.get(opts, :preload, [])

    PlayerAvailability
    |> Repo.get_by(team_round_id: team_round_id, team_player_id: team_player_id)
    |> case do
      nil ->
        %PlayerAvailability{}
        |> PlayerAvailability.changeset(attrs)
        |> Repo.insert()

      player_availability ->
        player_availability
        |> PlayerAvailability.changeset(attrs)
        |> Repo.update()
    end
    |> case do
      {:ok, player_availability} ->
        {:ok, Repo.preload(player_availability, preload)}

      error ->
        error
    end
  end

  @doc """
  Updates a player_availability.

  ## Examples

      iex> update_player_availability(player_availability, %{field: new_value})
      {:ok, %PlayerAvailability{}}

      iex> update_player_availability(player_availability, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_availability(%PlayerAvailability{} = player_availability, attrs) do
    player_availability
    |> PlayerAvailability.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_availability.

  ## Examples

      iex> delete_player_availability(player_availability)
      {:ok, %PlayerAvailability{}}

      iex> delete_player_availability(player_availability)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_availability(%PlayerAvailability{} = player_availability) do
    Repo.delete(player_availability)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_availability changes.

  ## Examples

      iex> change_player_availability(player_availability)
      %Ecto.Changeset{data: %PlayerAvailability{}}

  """
  def change_player_availability(%PlayerAvailability{} = player_availability, attrs \\ %{}) do
    PlayerAvailability.changeset(player_availability, attrs)
  end

  def put_tornments_team_rounds(tournments) do
    Enum.map(tournments, &put_tornment_team_rounds/1)
  end

  defp put_tornment_team_rounds(%{next_round: %{id: round_id}, teams: teams} = tournment) do
    teams =
      Enum.map(teams, fn %{id: team_id} = team ->
        {:ok, team_round} =
          put_team_round(%{round_id: round_id, team_id: team_id},
            preload: [team: :players],
            with_opponent: true
          )

        players =
          team_round.team.players
          |> Enum.map(fn %{id: team_player_id} ->
            {:ok, player} =
              put_player_availability(
                %{
                  team_player_id: team_player_id,
                  team_round_id: team_round.id
                },
                preload: [team_player: [:player]]
              )

            player
          end)

        %{team | next_round: %{team_round | players: players}}
      end)

    %{tournment | teams: teams}
  end
end
