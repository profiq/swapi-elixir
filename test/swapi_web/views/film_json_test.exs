defmodule SWAPIWeb.FilmJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.SpeciesFixtures
  import SWAPI.StarshipsFixtures
  import SWAPI.VehiclesFixtures

  alias SWAPI.Schemas.Film
  alias SWAPIWeb.FilmJSON

  describe "show" do
    setup do
      film =
        film_fixture()
        |> Film.changeset(%{})
        |> put_assoc(:species, [species_fixture()])
        |> put_assoc(:starships, [starship_fixture()])
        |> put_assoc(:vehicles, [vehicle_fixture()])
        |> put_assoc(:characters, [person_fixture()])
        |> put_assoc(:planets, [planet_fixture()])
        |> Repo.update!()

      {:ok, %{film: film}}
    end

    test "renders an item", %{film: film} do
      assert %{
               id: id,
               title: title,
               episode_id: episode_id,
               opening_crawl: opening_crawl,
               director: director,
               producer: producer,
               release_date: release_date,
               species: [species_url],
               starships: [starship_url],
               vehicles: [vehicle_url],
               characters: [person_url],
               planets: [planet_url],
               url: url,
               created: created,
               edited: edited
             } = FilmJSON.show(%{film: film})

      assert id == film.id
      assert title == film.title
      assert episode_id == film.episode_id
      assert opening_crawl == film.opening_crawl
      assert director == film.director
      assert producer == film.producer
      assert release_date == film.release_date
      assert created == film.created
      assert edited == film.edited

      assert String.ends_with?(url, "/api/films/#{film.id}")
      assert String.ends_with?(species_url, "/api/species/#{List.first(film.species).id}")
      assert String.ends_with?(starship_url, "/api/starships/#{List.first(film.starships).id}")
      assert String.ends_with?(vehicle_url, "/api/vehicles/#{List.first(film.vehicles).id}")
      assert String.ends_with?(person_url, "/api/people/#{List.first(film.characters).id}")
      assert String.ends_with?(planet_url, "/api/planets/#{List.first(film.planets).id}")
    end
  end

  describe "index" do
    setup do
      films = for _ <- 1..10, do: film_fixture()
      meta = %{count: length(films), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/films", query_params: %{"page" => 1}}

      {:ok, %{films: films, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{films: films, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = FilmJSON.index(%{films: films, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(films)
    end

    test "puts a link to next page if there is one", %{films: films, meta: meta, conn: conn} do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = FilmJSON.index(%{films: films, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/films?page=2")
    end

    test "puts a link to previous page if there is one", %{films: films, meta: meta, conn: conn} do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = FilmJSON.index(%{films: films, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/films?page=2")
    end
  end
end
