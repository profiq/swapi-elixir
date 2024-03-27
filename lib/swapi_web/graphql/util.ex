defmodule SWAPIWeb.GraphQL.Util do
  def transport_field_callback(parent, _args, %{path: [field | _]}) do
    case Map.get(parent.transport, field.schema_node.identifier) do
      nil -> {:error, "Invalid transport field"}
      value -> {:ok, value}
    end
  end

  def transport_field_callback(_parent, _args, _info),
    do: {:error, "Invalid transport field"}
end
