defmodule Mix.Tasks.Scrap do
  use Mix.Task

  # @base_url "https://info64.org"
  def run(_args) do
    Mix.Task.run("app.start")
    # IO.inspect(args, label: "args")

    "https://ratings.fide.com/profile/54789699"
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
          |> String.to_integer(),
        gender: Floki.text(gender)
      }
    end)
    |> IO.inspect()
  end
end
