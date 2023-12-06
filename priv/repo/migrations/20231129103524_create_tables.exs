defmodule SWAPI.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:films) do
      add :title, :string
      add :episode_id, :integer
      add :opening_crawl, :text
      add :director, :string
      add :producer, :string
      add :release_date, :date

      timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
    end

    create table(:planets) do
      add :name, :string
      add :diameter, :string
      add :rotation_period, :string
      add :orbital_period, :string
      add :gravity, :string
      add :population, :string
      add :climate, :string
      add :terrain, :string
      add :surface_water, :string

      timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
    end

    create table(:people) do
      add :name, :string
      add :birth_year, :string
      add :eye_color, :string
      add :gender, :string
      add :hair_color, :string
      add :height, :string
      add :mass, :string
      add :skin_color, :string
      add :homeworld_id, references(:planets, on_delete: :nothing)

      timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
    end

    create table(:species) do
      add :name, :string
      add :classification, :string
      add :designation, :string
      add :average_height, :string
      add :average_lifespan, :string
      add :eye_colors, :string
      add :hair_colors, :string
      add :skin_colors, :string
      add :language, :string
      add :homeworld_id, references(:planets, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
    end

    create table(:transport) do
      add :name, :string
      add :model, :string
      add :manufacturer, :string
      add :length, :string
      add :cost_in_credits, :string
      add :crew, :string
      add :passengers, :string
      add :max_atmosphering_speed, :string
      add :cargo_capacity, :string
      add :consumables, :string

      timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
    end

    create table(:starships, primary_key: false) do
      add :id, references(:transport, on_delete: :nothing), primary_key: true
      add :starship_class, :string
      add :hyperdrive_rating, :string
      add :mglt, :string
    end

    create table(:vehicles, primary_key: false) do
      add :id, references(:transport, on_delete: :nothing), primary_key: true
      add :vehicle_class, :string
    end

    create table(:film_characters) do
      add :film_id, references(:films, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)
    end

    create table(:film_planets) do
      add :film_id, references(:films, on_delete: :nothing)
      add :planet_id, references(:planets, on_delete: :nothing)
    end

    create table(:film_species) do
      add :film_id, references(:films, on_delete: :nothing)
      add :species_id, references(:species, on_delete: :nothing)
    end

    create table(:film_starships) do
      add :film_id, references(:films, on_delete: :nothing)
      add :starship_id, references(:starships, on_delete: :nothing)
    end

    create table(:film_vehicles) do
      add :film_id, references(:films, on_delete: :nothing)
      add :vehicle_id, references(:vehicles, on_delete: :nothing)
    end

    create table(:people_species) do
      add :person_id, references(:people, on_delete: :nothing)
      add :species_id, references(:species, on_delete: :nothing)
    end

    create table(:starship_pilots) do
      add :starship_id, references(:starships, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)
    end

    create table(:vehicle_pilots) do
      add :vehicle_id, references(:vehicles, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)
    end
  end
end
