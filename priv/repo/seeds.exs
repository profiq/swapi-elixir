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
  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Person
  alias SWAPI.Schemas.Planet
  alias SWAPI.Schemas.Species
  alias SWAPI.Schemas.Starship
  alias SWAPI.Schemas.Transport
  alias SWAPI.Schemas.Vehicle

  import Ecto.Changeset
  import Ecto.Query

  defp insert_film(film) do
    {assocs, fields} =
      Map.split(film["fields"], ["characters", "planets", "species", "starships", "vehicles"])

    %Film{}
    |> change(id: film["pk"])
    |> Film.changeset(fields)
    |> put_assoc(:characters, Repo.all(from x in Person, where: x.id in ^assocs["characters"]))
    |> put_assoc(:planets, Repo.all(from x in Planet, where: x.id in ^assocs["planets"]))
    |> put_assoc(:species, Repo.all(from x in Species, where: x.id in ^assocs["species"]))
    |> put_assoc(:starships, Repo.all(from x in Starship, where: x.id in ^assocs["starships"]))
    |> put_assoc(:vehicles, Repo.all(from x in Vehicle, where: x.id in ^assocs["vehicles"]))
    |> Repo.insert!()
  end

  defp insert_planet(planet) do
    %Planet{}
    |> change(id: planet["pk"])
    |> Planet.changeset(planet["fields"])
    |> Repo.insert!()
  end

  defp insert_person(person) do
    {homeworld_id, fields} = Map.pop(person["fields"], "homeworld")

    %Person{}
    |> change(id: person["pk"], homeworld_id: homeworld_id)
    |> Person.changeset(fields)
    |> Repo.insert!()
  end

  defp insert_species(species) do
    {assocs, fields} = Map.split(species["fields"], ["homeworld", "people"])

    %Species{}
    |> change(id: species["pk"], homeworld_id: assocs["homeworld"])
    |> Species.changeset(fields)
    |> put_assoc(:people, Repo.all(from x in Person, where: x.id in ^assocs["people"]))
    |> Repo.insert!()
  end

  defp insert_starship(starship) do
    {pilots, fields} = Map.pop(starship["fields"], "pilots", [])

    %Starship{}
    |> change(id: starship["pk"], mglt: starship["fields"]["MGLT"])
    |> Starship.changeset(fields)
    |> put_assoc(:pilots, Repo.all(from x in Person, where: x.id in ^pilots))
    |> Repo.insert!()
  end

  defp insert_transport(transport) do
    %Transport{}
    |> change(id: transport["pk"])
    |> Transport.changeset(transport["fields"])
    |> Repo.insert!()
  end

  defp insert_vehicle(vehicle) do
    {pilots, fields} = Map.pop(vehicle["fields"], "pilots", [])

    %Vehicle{}
    |> change(id: vehicle["pk"])
    |> Vehicle.changeset(fields)
    |> put_assoc(:pilots, Repo.all(from x in Person, where: x.id in ^pilots))
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
