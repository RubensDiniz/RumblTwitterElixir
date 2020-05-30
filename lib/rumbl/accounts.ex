defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Rumbl.{Repo, User}

  def get_user!(user_id) do
    Repo.get!(User, user_id)
  end
end
