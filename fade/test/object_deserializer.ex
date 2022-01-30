defmodule ObjectDeserializer do
  def get_data(file_name, mapper) do
    with {:ok, data} <- File.read(file_name),
         {:ok, deserialized_object} <- Jason.decode(data) do
      deserialized_object |> mapper.()
    else
      {:error, err} ->
        {:error, err}
    end
  end
end
