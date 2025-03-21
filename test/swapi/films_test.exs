defmodule SWAPI.FilmsTest do
  use SWAPI.DataCase

  alias SWAPI.Films

  describe "films" do
    alias SWAPI.Schemas.Film

    import SWAPI.FilmsFixtures

    @invalid_attrs %{
      title: nil,
      episode_id: nil,
      opening_crawl: nil,
      director: nil,
      producer: nil,
      release_date: nil
    }

    test "list_films/0 returns all films" do
      film = film_fixture()
      assert [^film] = Films.list_films() |> Enum.map(&Films.preload_all/1)
    end

    test "list_films/1 returns all films" do
      film = film_fixture()
      assert {:ok, {films, _}} = Films.list_films(%{})
      assert [^film] = Enum.map(films, &Films.preload_all/1)
    end

    test "search_films/1 returns only matching films" do
      film = film_fixture(%{title: "foo bar baz"})
      film_fixture(%{title: "foo bar"})
      film_fixture(%{title: "foo"})

      assert {:ok, {films, _}} = Films.search_films(["foo", "bar", "baz"], %{})
      assert [^film] = Enum.map(films, &Films.preload_all/1)
    end

    test "get_film!/1 returns the film with given id" do
      film = film_fixture()
      assert ^film = Films.get_film!(film.id) |> Films.preload_all()
    end

    test "get_film/1 returns the film with given id" do
      film = film_fixture()
      assert {:ok, returned_film} = Films.get_film(film.id)
      assert ^film = Films.preload_all(returned_film)
    end

    test "get_film/1 returns error when given id does not exist" do
      assert {:error, :not_found} = Films.get_film(42)
    end

    test "create_film/1 with valid data creates a film" do
      valid_attrs = %{
        title: "some title",
        episode_id: 42,
        opening_crawl: "some opening_crawl",
        director: "some director",
        producer: "some producer",
        release_date: ~D[2023-11-28]
      }

      assert {:ok,
              %Film{
                title: "some title",
                episode_id: 42,
                opening_crawl: "some opening_crawl",
                director: "some director",
                producer: "some producer",
                release_date: ~D[2023-11-28]
              }} = Films.create_film(valid_attrs)
    end

    test "create_film/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Films.create_film(@invalid_attrs)
    end

    test "update_film/2 with valid data updates the film" do
      film = film_fixture()

      update_attrs = %{
        title: "some updated title",
        episode_id: 43,
        opening_crawl: "some updated opening_crawl",
        director: "some updated director",
        producer: "some updated producer",
        release_date: ~D[2023-11-29]
      }

      assert {:ok,
              %Film{
                title: "some updated title",
                episode_id: 43,
                opening_crawl: "some updated opening_crawl",
                director: "some updated director",
                producer: "some updated producer",
                release_date: ~D[2023-11-29]
              }} = Films.update_film(film, update_attrs)
    end

    test "update_film/2 with invalid data returns error changeset" do
      film = film_fixture()
      assert {:error, %Ecto.Changeset{}} = Films.update_film(film, @invalid_attrs)
      assert ^film = Films.get_film!(film.id) |> Films.preload_all()
    end

    test "delete_film/1 deletes the film" do
      film = film_fixture()
      assert {:ok, %Film{}} = Films.delete_film(film)
      assert_raise Ecto.NoResultsError, fn -> Films.get_film!(film.id) end
    end

    test "change_film/1 returns a film changeset" do
      film = film_fixture()
      assert %Ecto.Changeset{} = Films.change_film(film)
    end
  end
end
