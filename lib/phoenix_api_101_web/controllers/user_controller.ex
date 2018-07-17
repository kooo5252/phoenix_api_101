defmodule PhoenixApi101Web.UserController do
  use PhoenixApi101Web, :controller

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User
  alias JaSerializer.Params
  alias PhoenixApi101.Repo
  import Ecto.Changeset

  action_fallback(PhoenixApi101Web.FallbackController)

  def index(conn, params) do
    #    users = Accounts.list_users()

    page =
      User
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json-api", data: page.entries)
  end

  def create(conn, %{"data" => _data = %{"type" => "user", "attributes" => user_params}}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do

#-------------------------------------------------------------------------      
      case  Repo.insert( User.changeset(%User{}, user_params) ) do
        {:ok, _changeset} -> 
          conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json-api", data: user)
         {:error, _changeset} ->
          conn
          |> put_status(:Conflict)
          |> render("create.json-api", data: user)

#-------------------------------------------------------------------------

#      conn
#      |> put_status(:created)
#      |> put_resp_header("location", user_path(conn, :show, user))
#      |> render("show.json-api", data: user)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{
        "id" => id,
        "data" => _data = %{"type" => "user", "attributes" => user_params}
      }) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
