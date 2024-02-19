defmodule SWAPI.PaginationTest do
  use SWAPI.DataCase

  alias SWAPI.Pagination
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
      assert {:ok, {_, %{count: 42, next: {:page, 2}, previous: nil}}} =
               Pagination.paginate(Person, %{})
    end

    test "returns the specified page when page parameter is provided" do
      assert {:ok, {_, %{count: 42, next: {:page, 3}, previous: {:page, 1}}}} =
               Pagination.paginate(Person, %{"page" => "2"})
    end

    test "returns empty list when page parameter is out of bounds" do
      assert {:ok, {[], %{count: 42, next: _, previous: _}}} =
               Pagination.paginate(Person, %{"page" => "100"})
    end

    test "returns the set number of items when page size is specified" do
      assert {:ok, {[_], _}} = Pagination.paginate(Person, %{"page" => "1", "limit" => "1"})
    end

    test "returns correctly offset items for given page size" do
      assert {:ok, {[person], _}} = Pagination.paginate(Person, %{"page" => "2", "limit" => "1"})
      assert %{id: 2} = person
    end

    test "works with offset parameter" do
      assert {:ok, {[person | _], _}} = Pagination.paginate(Person, %{"offset" => "1"})
      assert %{id: 2} = person
    end

    test "works with offset and limit parameter" do
      assert {:ok, {[person], _}} =
               Pagination.paginate(Person, %{"offset" => "1", "limit" => "1"})

      assert %{id: 2} = person
    end

    test "returns correct next and previous offsets" do
      assert {:ok, {_, %{next: {:offset, 4}, previous: {:offset, 2}}}} =
               Pagination.paginate(Person, %{"offset" => "3", "limit" => "1"})
    end

    test "previous offset is nil for first item" do
      assert {:ok, {_, %{previous: nil}}} = Pagination.paginate(Person, %{"offset" => "0"})
    end

    test "last offset is nil for last item" do
      assert {:ok, {_, %{next: nil}}} = Pagination.paginate(Person, %{"offset" => "41"})
    end

    test "returns error when page parameter is not a number" do
      assert {:error, :bad_request} = Pagination.paginate(Person, %{"page" => "not_a_number"})
    end

    test "returns error when using pages and limit is not a number" do
      assert {:error, :bad_request} =
               Pagination.paginate(Person, %{"page" => "1", "limit" => "not_a_number"})
    end

    test "returns error when offset parameter is not a number" do
      assert {:error, :bad_request} = Pagination.paginate(Person, %{"offset" => "not_a_number"})
    end

    test "returns error when using offsets and limit parameter is not a number" do
      assert {:error, :bad_request} =
               Pagination.paginate(Person, %{"offset" => "1", "limit" => "not_a_number"})
    end

    test "returns error when both page and offset are provided" do
      assert {:error, :bad_request} =
               Pagination.paginate(Person, %{"page" => "1", "offset" => "1"})
    end
  end
end
