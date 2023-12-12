# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SWAPI.Repo.insert!(%SWAPI.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SWAPI.Repo.Seeds do
  alias SWAPI.Repo
  alias SWAPI.Schemas.{Film, Person, Planet, Species, Starship, Transport, Vehicle}

  import Ecto.Changeset
  import Ecto.Query

  defp insert_film(film) do
    %Film{}
    |> change(id: film["pk"])
    |> Film.changeset(film["fields"])
    |> put_assoc(:characters, Repo.all(from x in Person, where: x.id in ^film["fields"]["characters"]))
    |> put_assoc(:planets, Repo.all(from x in Planet, where: x.id in ^film["fields"]["planets"]))
    |> put_assoc(:species, Repo.all(from x in Species, where: x.id in ^film["fields"]["species"]))
    |> put_assoc(:starships, Repo.all(from x in Starship, where: x.id in ^film["fields"]["starships"]))
    |> put_assoc(:vehicles, Repo.all(from x in Vehicle, where: x.id in ^film["fields"]["vehicles"]))
    |> Repo.insert!()
  end

  defp insert_planet(planet) do
    %Planet{}
    |> change(id: planet["pk"])
    |> Planet.changeset(planet["fields"])
    |> Repo.insert!()
  end

  defp insert_person(person) do
    %Person{}
    |> change(id: person["pk"], homeworld_id: person["fields"]["homeworld"])
    |> Person.changeset(person["fields"])
    |> delete_change(:homeworld)
    |> Repo.insert!()
  end

  defp insert_species(species) do
    %Species{}
    |> change(id: species["pk"], homeworld_id: species["fields"]["homeworld"])
    |> Species.changeset(species["fields"])
    |> delete_change(:homeworld)
    |> put_assoc(:people, Repo.all(from x in Person, where: x.id in ^species["fields"]["people"]))
    |> Repo.insert!()
  end

  defp insert_starship(starship) do
    %Starship{}
    |> change(id: starship["pk"])
    |> change(mglt: starship["fields"]["MGLT"])
    |> Starship.changeset(starship["fields"])
    |> put_assoc(:pilots, Repo.all(from x in Person, where: x.id in ^starship["fields"]["pilots"]))
    |> Repo.insert!()
  end

  defp insert_transport(transport) do
    %Transport{}
    |> change(id: transport["pk"])
    |> Transport.changeset(transport["fields"])
    |> Repo.insert!()
  end

  defp insert_vehicle(vehicle) do
    %Vehicle{}
    |> change(id: vehicle["pk"])
    |> Vehicle.changeset(vehicle["fields"])
    |> put_assoc(:pilots, Repo.all(from x in Person, where: x.id in ^vehicle["fields"]["pilots"]))
    |> Repo.insert!()
  end

  defp insert_table(path, fun) do
    path
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(fun)
  end

  def run() do
    insert_table("#{__DIR__}/fixtures/planets.json", &insert_planet/1)
    insert_table("#{__DIR__}/fixtures/people.json", &insert_person/1)
    insert_table("#{__DIR__}/fixtures/species.json", &insert_species/1)
    insert_table("#{__DIR__}/fixtures/transport.json", &insert_transport/1)
    insert_table("#{__DIR__}/fixtures/starships.json", &insert_starship/1)
    insert_table("#{__DIR__}/fixtures/vehicles.json", &insert_vehicle/1)
    insert_table("#{__DIR__}/fixtures/films.json", &insert_film/1)
  end
end

SWAPI.Repo.Seeds.run()
