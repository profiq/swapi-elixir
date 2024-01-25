defmodule SWAPIWeb.Schemas do
  @moduledoc """
  OpenAPI schemas for SWAPI resources
  """

  defmodule Root do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "The Root resource provides information on all available resources within the API.",
      properties: %{
        films: %Schema{
          type: :string,
          description: "The URL root for Film resources"
        },
        people: %Schema{
          type: :string,
          description: "The URL root for People resources"
        },
        planets: %Schema{
          type: :string,
          description: "The URL root for Planet resources"
        },
        species: %Schema{
          type: :string,
          description: "The URL root for Species resources"
        },
        starships: %Schema{
          type: :string,
          description: "The URL root for Starships resources"
        },
        vehicles: %Schema{
          type: :string,
          description: "The URL root for Vehicles resources"
        }
      }
    })
  end

  defmodule List do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      properties: %{
        count: %Schema{
          type: :integer,
          description:
            "Total count of records in this list. Note that the IDs are not sequential, you should not make any assumptions about the range of valid IDs based on this value."
        },
        next: %Schema{
          type: :string,
          description: "The URL to the next page, or `null` if there is no next page."
        },
        previous: %Schema{
          type: :string,
          description: "The URL to the previous page, or `null` if there is no previous page."
        }
      }
    })
  end

  defmodule Item do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      properties: %{
        url: %Schema{
          type: :string,
          description: "The hypermedia URL of this resource."
        },
        created: %Schema{
          type: :string,
          description: "The ISO 8601 date format of the time that this resource was created."
        },
        edited: %Schema{
          type: :string,
          description: "The ISO 8601 date format of the time that this resource was edited."
        }
      }
    })
  end

  defmodule Error do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      properties: %{
        detail: %Schema{
          type: :string,
          description: "Error message"
        }
      }
    })
  end

  defmodule Film do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description: "A Film resource is a single film.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            title: %Schema{
              type: :string,
              description: "The title of this film."
            },
            episode_id: %Schema{
              type: :integer,
              description: "The episode number of this film."
            },
            opening_crawl: %Schema{
              type: :string,
              description: "The opening paragraphs at the beginning of this film."
            },
            director: %Schema{
              type: :string,
              description: "The name of the director of this film."
            },
            producer: %Schema{
              type: :string,
              description: "The name(s) of the producer(s) of this film. Comma separated."
            },
            release_date: %Schema{
              type: :string,
              description: "The ISO 8601 date format of film release at original creator country."
            },
            species: %Schema{
              type: :array,
              description: "An array of species resource URLs that are in this film.",
              items: %Schema{type: :string}
            },
            starships: %Schema{
              type: :array,
              description: "An array of starship resource URLs that are in this film.",
              items: %Schema{type: :string}
            },
            vehicles: %Schema{
              type: :array,
              description: "An array of vehicle resource URLs that are in this film.",
              items: %Schema{type: :string}
            },
            characters: %Schema{
              type: :array,
              description: "An array of people resource URLs that are in this film.",
              items: %Schema{type: :string}
            },
            planets: %Schema{
              type: :array,
              description: "An array of planet resource URLs that are in this film.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule FilmList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of films",
              items: Film
            }
          }
        }
      ]
    })
  end

  defmodule Person do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "A People resource is an individual person or character within the Star Wars universe.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            name: %Schema{
              type: :string,
              description: "The name of this person."
            },
            birth_year: %Schema{
              type: :string,
              description:
                "The birth year of the person, using the in-universe standard of **BBY** or **ABY** - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope."
            },
            eye_color: %Schema{
              type: :string,
              description:
                "The eye color of this person. Will be \"unknown\" if not known or \"n/a\" if the person does not have an eye."
            },
            gender: %Schema{
              type: :string,
              description:
                "The gender of this person. Either \"Male\", \"Female\" or \"unknown\", \"n/a\" if the person does not have a gender."
            },
            hair_color: %Schema{
              type: :string,
              description:
                "The hair color of this person. Will be \"unknown\" if not known or \"n/a\" if the person does not have hair."
            },
            height: %Schema{
              type: :string,
              description: "The height of the person in centimeters."
            },
            mass: %Schema{
              type: :string,
              description: "The mass of the person in kilograms."
            },
            skin_color: %Schema{
              type: :string,
              description: "The skin color of this person."
            },
            homeworld: %Schema{
              type: :string,
              description:
                "The URL of a planet resource, a planet that this person was born on or inhabits."
            },
            films: %Schema{
              type: :array,
              description: "An array of film resource URLs that this person has been in.",
              items: %Schema{type: :string}
            },
            species: %Schema{
              type: :array,
              description: "An array of species resource URLs that this person belongs to.",
              items: %Schema{type: :string}
            },
            vehicles: %Schema{
              type: :array,
              description: "An array of starship resource URLs that this person has piloted.",
              items: %Schema{type: :string}
            },
            starships: %Schema{
              type: :array,
              description: "An array of vehicle resource URLs that this person has piloted.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule PersonList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of people",
              items: Person
            }
          }
        }
      ]
    })
  end

  defmodule Planet do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "A Planet resource is a large mass, planet or planetoid in the Star Wars Universe, at the time of 0 ABY.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            name: %Schema{
              type: :string,
              description: "The name of this planet."
            },
            diameter: %Schema{
              type: :string,
              description: "The diameter of this planet in kilometers."
            },
            rotation_period: %Schema{
              type: :string,
              description:
                "The number of standard hours it takes for this planet to complete a single rotation on its axis."
            },
            orbital_period: %Schema{
              type: :string,
              description:
                "The number of standard days it takes for this planet to complete a single orbit of its local star."
            },
            gravity: %Schema{
              type: :string,
              description:
                "A number denoting the gravity of this planet, where \"1\" is normal or 1 standard G. \"2\" is twice or 2 standard Gs. \"0.5\" is half or 0.5 standard Gs."
            },
            population: %Schema{
              type: :string,
              description: "The average population of sentient beings inhabiting this planet."
            },
            climate: %Schema{
              type: :string,
              description: "The climate of this planet. Comma separated if diverse."
            },
            terrain: %Schema{
              type: :string,
              description: "The terrain of this planet. Comma separated if diverse."
            },
            surface_water: %Schema{
              type: :string,
              description:
                "The percentage of the planet surface that is naturally occurring water or bodies of water."
            },
            residents: %Schema{
              type: :array,
              description: "An array of People URL Resources that live on this planet.",
              items: %Schema{type: :string}
            },
            films: %Schema{
              type: :array,
              description: "An array of Film URL Resources that this planet has appeared in.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule PlanetList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of planets",
              items: Planet
            }
          }
        }
      ]
    })
  end

  defmodule Species do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "A Species resource is a type of person or character within the Star Wars Universe.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            name: %Schema{
              type: :string,
              description: "The name of this species."
            },
            classification: %Schema{
              type: :string,
              description:
                "The classification of this species, such as \"mammal\" or \"reptile\"."
            },
            designation: %Schema{
              type: :string,
              description: "The designation of this species, such as \"sentient\"."
            },
            average_height: %Schema{
              type: :string,
              description: "The average height of this species in centimeters."
            },
            average_lifespan: %Schema{
              type: :string,
              description: "The average lifespan of this species in years."
            },
            eye_colors: %Schema{
              type: :string,
              description:
                "A comma-separated string of common eye colors for this species, \"none\" if this species does not typically have eyes."
            },
            hair_colors: %Schema{
              type: :string,
              description:
                "A comma-separated string of common hair colors for this species, \"none\" if this species does not typically have hair."
            },
            skin_colors: %Schema{
              type: :string,
              description:
                "A comma-separated string of common skin colors for this species, \"none\" if this species does not typically have skin."
            },
            language: %Schema{
              type: :string,
              description: "The language commonly spoken by this species."
            },
            homeworld: %Schema{
              type: :string,
              description:
                "The URL of a planet resource, a planet that this species originates from."
            },
            people: %Schema{
              type: :array,
              description: "An array of People URL Resources that are a part of this species.",
              items: %Schema{type: :string}
            },
            films: %Schema{
              type: :array,
              description: "An array of Film URL Resources that this species has appeared in.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule SpeciesList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of species",
              items: Species
            }
          }
        }
      ]
    })
  end

  defmodule Starship do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "A Starship resource is a single transport craft that has hyperdrive capability.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            name: %Schema{
              type: :string,
              description: "The name of this starship. The common name, such as \"Death Star\"."
            },
            model: %Schema{
              type: :string,
              description:
                "The model or official name of this starship. Such as \"T-65 X-wing\" or \"DS-1 Orbital Battle Station\"."
            },
            starship_class: %Schema{
              type: :string,
              description:
                "The class of this starship, such as \"Starfighter\" or \"Deep Space Mobile Battlestation\""
            },
            manufacturer: %Schema{
              type: :string,
              description: "The manufacturer of this starship. Comma separated if more than one."
            },
            cost_in_credits: %Schema{
              type: :string,
              description: "The cost of this starship new, in galactic credits."
            },
            length: %Schema{
              type: :string,
              description: "The length of this starship in meters."
            },
            crew: %Schema{
              type: :string,
              description: "The number of personnel needed to run or pilot this starship."
            },
            passengers: %Schema{
              type: :string,
              description: "The number of non-essential people this starship can transport."
            },
            max_atmosphering_speed: %Schema{
              type: :string,
              description:
                "The maximum speed of this starship in the atmosphere. \"N/A\" if this starship is incapable of atmospheric flight."
            },
            hyperdrive_rating: %Schema{
              type: :string,
              description: "The class of this starships hyperdrive."
            },
            MGLT: %Schema{
              type: :string,
              description:
                "The Maximum number of Megalights this starship can travel in a standard hour. A \"Megalight\" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth."
            },
            cargo_capacity: %Schema{
              type: :string,
              description: "The maximum number of kilograms that this starship can transport."
            },
            consumables: %Schema{
              type: :string,
              description:
                "The maximum length of time that this starship can provide consumables for its entire crew without having to resupply."
            },
            films: %Schema{
              type: :array,
              description: "An array of Film URL Resources that this starship has appeared in.",
              items: %Schema{type: :string}
            },
            pilots: %Schema{
              type: :array,
              description:
                "An array of People URL Resources that this starship has been piloted by.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule StarshipList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of starships",
              items: Starship
            }
          }
        }
      ]
    })
  end

  defmodule Vehicle do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      description:
        "A Vehicle resource is a single transport craft that does not have hyperdrive capability.",
      allOf: [
        Item,
        %Schema{
          type: :object,
          properties: %{
            name: %Schema{
              type: :string,
              description:
                "The name of this vehicle. The common name, such as \"Sand Crawler\" or \"Speeder bike\"."
            },
            model: %Schema{
              type: :string,
              description:
                "The model or official name of this vehicle. Such as \"All-Terrain Attack Transport\"."
            },
            vehicle_class: %Schema{
              type: :string,
              description: "The class of this vehicle, such as \"Wheeled\" or \"Repulsorcraft\"."
            },
            manufacturer: %Schema{
              type: :string,
              description: "The manufacturer of this vehicle. Comma separated if more than one."
            },
            length: %Schema{
              type: :string,
              description: "The length of this vehicle in meters."
            },
            cost_in_credits: %Schema{
              type: :string,
              description: "The cost of this vehicle new, in Galactic Credits."
            },
            crew: %Schema{
              type: :string,
              description: "The number of personnel needed to run or pilot this vehicle."
            },
            passengers: %Schema{
              type: :string,
              description: "The number of non-essential people this vehicle can transport."
            },
            max_atmosphering_speed: %Schema{
              type: :string,
              description: "The maximum speed of this vehicle in the atmosphere."
            },
            cargo_capacity: %Schema{
              type: :string,
              description: "The maximum number of kilograms that this vehicle can transport."
            },
            consumables: %Schema{
              type: :string,
              description:
                "The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply."
            },
            films: %Schema{
              type: :array,
              description: "An array of Film URL Resources that this vehicle has appeared in.",
              items: %Schema{type: :string}
            },
            pilots: %Schema{
              type: :array,
              description:
                "An array of People URL Resources that this vehicle has been piloted by.",
              items: %Schema{type: :string}
            }
          }
        }
      ]
    })
  end

  defmodule VehicleList do
    @moduledoc false

    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      type: :object,
      allOf: [
        List,
        %Schema{
          type: :object,
          properties: %{
            results: %Schema{
              type: :array,
              description: "The list of vehicles",
              items: Vehicle
            }
          }
        }
      ]
    })
  end
end
