defmodule Phoneapp.Dictionary do
  use Ecto.Schema

  schema "dictionary" do
    field :object, :map
  end
end
