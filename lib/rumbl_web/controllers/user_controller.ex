defmodule RumblWeb.UserController do
    use RumblWeb, :controller
    alias Rumbl.User
    alias Rumbl.Repo

    plug :authenticate when action in [:index, :show]

    def index(conn, _params) do
        users = Repo.all(User)
        render conn, "index.html", users: users
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get(User, id)
        render(conn, "show.html", user: user)
    end

    def new(conn, _params) do
        changeset = User.changeset(%User{}, %{})
        render(conn, "new.html", changeset: changeset)
    end

    #def create(conn, %{"user" => user_params}) do
    #    changeset = User.changeset(%User{}, user_params)
    #    {:ok, user} = Repo.insert(changeset)
    #    conn
    #        |> put_flash(:info, "#{user.name} created!")
    #        |> redirect(to: Routes.user_path(conn, :index))
    #end

    def create(conn, %{"user" => user_params}) do
        changeset = User.changeset(%User{}, user_params)
        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> Rumbl.Auth.login(user)
                |> put_flash(:info, "#{user.name} created!")
                |> redirect(to: Routes.user_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}) do
        case Repo.get(User, id) do
            nil ->
                conn
                |> put_flash(:error, "User not found")
                |> redirect(to: Routes.user_path(conn, :index))

            user ->
                Repo.delete(user)
                conn
                |> put_flash(:info, "User deleted")
                |> redirect(to: Routes.user_path(conn, :index))
        end
    end

    defp authenticate(conn, _opts) do
        if conn.assigns.current_user do
            conn
        else
            conn
            |> put_flash(:error, "You must be logged in to access that page")
            |> redirect(to: Routes.page_path(conn, :index))
            |> halt()
        end
    end
end