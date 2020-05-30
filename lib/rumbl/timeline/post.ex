defmodule Rumbl.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    field :username, :string, virtual: true
    field :user_id, :id, default: 1

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:username, :body, :likes_count, :reposts_count])
    |> validate_required([:body, :likes_count, :reposts_count])
  end
end