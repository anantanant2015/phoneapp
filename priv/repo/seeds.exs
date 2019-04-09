# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Phoneapp.Repo.insert!(%Phoneapp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule DataOperation do
  alias Phoneapp.{Dictionary, Repo}

  @digit_map %{
    "A" => 2,
    "B" => 2,
    "C" => 2,
    "D" => 3,
    "E" => 3,
    "F" => 3,
    "G" => 4,
    "H" => 4,
    "I" => 4,
    "J" => 5,
    "K" => 5,
    "L" => 5,
    "M" => 6,
    "N" => 6,
    "O" => 6,
    "P" => 7,
    "Q" => 7,
    "R" => 7,
    "S" => 7,
    "T" => 8,
    "U" => 8,
    "V" => 8,
    "W" => 9,
    "X" => 9,
    "Y" => 9,
    "Z" => 9
  }

  def wordToNumber(word) do
    word
    |> String.graphemes()
    |> Enum.map(fn x -> Map.get(@digit_map, x) end)
    |> Enum.join()
  end

  def mapBuilder(wordlist) do
    wordlist
    |> Enum.into(%{}, fn x -> {x, %{number: DataOperation.wordToNumber(x), word: x}} end)
  end

  def insertDictionary(object) do
    dictionary = Repo.insert!(%Dictionary{object: object})
    IO.inspect(dictionary)
  end
end

start_time = DateTime.utc_now()
{:ok, file_data} = "dictionary.txt" |> Path.absname() |> File.read()

file_data_list = file_data |> String.split("\n") |> Enum.filter(fn x -> String.length(x) > 2 end)

file_data_map = file_data_list |> DataOperation.mapBuilder()

DataOperation.insertDictionary(file_data_map)
end_time = DateTime.utc_now()

IO.inspect(DateTime.diff(end_time, start_time, :millisecond))
