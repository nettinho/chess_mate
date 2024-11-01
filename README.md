# ChessMate

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

mix phx.gen.context Roster Player players fide name user_id:references:users
mix phx.gen.context Roster Tournment tournments name
mix phx.gen.context Roster Team teams tournment_id:references:tournments name

mix phx.gen.context Roster PlayerTeam players_teams player_id:references:players team_id:references:teams board_number:integer

mix phx.gen.context Roster Round rounds tournment_id:references:tournments round:integer timestamp:utc_datetime
mix phx.gen.context Roster Game games round_id:references:rounds white_id:references:players_teams black_id:references:players_teams result

mix phx.gen.context Playbook TeamRound team_round round_id:references:rounds comments:text lineup:array:integer
mix phx.gen.context Playbook PlayerAvailability player_availability team_round_id:references:team_rounds team_player_id:references:team_players status

mix phx.gen.live Accounts UserRole user_roles user_id:references:users role team_prefix
