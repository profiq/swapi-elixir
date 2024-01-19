defmodule SWAPI.FilmsTest do
  use SWAPI.DataCase

  alias SWAPI.Films

  describe "films" do
    alias SWAPI.Schemas.Film

    import SWAPI.FilmsFixtures

    @invalid_attrs %{title: nil, episode_id: nil, opening_crawl: nil, director: nil, producer: nil, release_date: nil}

    test "list_films/0 returns all films" do
      film = film_fixture()
      assert Films.list_films() == [film]
    end

    test "list_films/1 returns all films" do
      film = film_fixture()
      assert {:ok, {[^film], _}} = Films.list_films(%{})
    end

    test "search_films/1 returns only matching films" do
      film = film_fixture(%{title: "foo bar baz"})
      film_fixture(%{title: "foo bar"})
      film_fixture(%{title: "foo"})

      assert {:ok, {[^film], _}} = Films.search_films(["foo", "bar", "baz"], %{})
    end

    test "get_film!/1 returns the film with given id" do
      film = film_fixture()
      assert Films.get_film!(film.id) == film
    end

    test "get_film/1 returns the film with given id" do
      film = film_fixture()
      assert Films.get_film(film.id) == {:ok, film}
    end

    test "get_film/1 returns error when given id does not exist" do
      assert Films.get_film(42) == {:error, :not_found}
    end

    test "create_film/1 with valid data creates a film" do
      valid_attrs = %{title: "some title", episode_id: 42, opening_crawl: "some opening_crawl", director: "some director", producer: "some producer", release_date: ~D[2023-11-28]}

      assert {:ok, %Film{} = film} = Films.create_film(valid_attrs)
      assert film.title == "some title"
      assert film.episode_id == 42
      assert film.opening_crawl == "some opening_crawl"
      assert film.director == "some director"
      assert film.producer == "some producer"
      assert film.release_date == ~D[2023-11-28]
    end

    test "create_film/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Films.create_film(@invalid_attrs)
    end

    test "update_film/2 with valid data updates the film" do
      film = film_fixture()
      update_attrs = %{title: "some updated title", episode_id: 43, opening_crawl: "some updated opening_crawl", director: "some updated director", producer: "some updated producer", release_date: ~D[2023-11-29]}

      assert {:ok, %Film{} = film} = Films.update_film(film, update_attrs)
      assert film.title == "some updated title"
      assert film.episode_id == 43
      assert film.opening_crawl == "some updated opening_crawl"
      assert film.director == "some updated director"
      assert film.producer == "some updated producer"
      assert film.release_date == ~D[2023-11-29]
    end

    test "update_film/2 with invalid data returns error changeset" do
      film = film_fixture()
      assert {:error, %Ecto.Changeset{}} = Films.update_film(film, @invalid_attrs)
      assert film == Films.get_film!(film.id)
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
