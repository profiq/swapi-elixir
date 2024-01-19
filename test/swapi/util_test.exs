defmodule SWAPI.UtilTest do
  use SWAPI.DataCase

  alias SWAPI.Util
  alias SWAPI.Schemas.Person

  import SWAPI.PeopleFixtures

  describe "paginate/2" do
    setup do
      for i <- 1..42 do
        person_fixture(%{name: "Person #{i}"})
      end

      :ok
    end

    test "returns the first page when no page parameter is provided" do
      assert {:ok, {_, %{count: 42, next: 2, previous: nil}}} = Util.paginate(Person, %{})
    end

    test "returns the specified page when page parameter is provided" do
      assert {:ok, {_, %{count: 42, next: 3, previous: 1}}} = Util.paginate(Person, %{"page" => "2"})
    end

    test "returns empty list when page parameter is out of bounds" do
      assert {:ok, {[], %{count: 42, next: _, previous: _}}} = Util.paginate(Person, %{"page" => "100"})
    end

    test "returns error when page parameter is not a number" do
      assert {:error, :bad_request} = Util.paginate(Person, %{"page" => "not_a_number"})
    end
  end
end
