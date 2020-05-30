defmodule RumblWeb.UserView do
    use RumblWeb, :view
    alias Rumbl.User

    def first_name(%User{name: word}) do
        word |> String.split(" ") |> Enum.at(0)
    end
    
end