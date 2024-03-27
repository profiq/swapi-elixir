defmodule SWAPIWeb.GraphQL.Util do
  def transport_field_callback(transport, _parent, _args, %{path: [field | _]}) do
    case Map.get(transport, field.schema_node.identifier) do
      nil -> {:error, "Invalid transport field"}
      value -> {:ok, value}
    end
  end

  def transport_field_callback(_transport, _parent, _args, _info),
    do: {:error, "Invalid transport field"}
end
