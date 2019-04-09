defmodule Phoneapp.EtsCache do
  @cache_table :key_lookup
  alias Phoneapp.{Dictionary, Repo}

  def start() do
    data = Repo.one(Dictionary)
    ets_init({"number_list", data.object})
  end

  def ets_lookup(key) do
    :ets.lookup(:key_lookup, key)
  end

  defp ets_init(data) do
    :ets.new(:key_lookup, [:set, :protected, :named_table])
    :ets.insert(:key_lookup, data)
  end
end
