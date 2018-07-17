defmodule PhoenixApi101Web.AuthView do
  use PhoenixApi101Web, :view
  use JaSerializer.PhoenixView

  attributes([:password, :username, :inserted_at, :updated_at])
end
