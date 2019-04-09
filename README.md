# Phoneapp

To start with the app:

  * `Dictionary` file should be kept the `root`.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
Here you can enter any number and see the result list along with time taken and number of sets.

Prequisits:

  * [`Phoenix`](https://hexdocs.pm/phoenix/installation.html) 
  * Elixir, Erlang, Postgres should be preinstalled, follow the guide in 
    [`Phoenix`](https://hexdocs.pm/phoenix/installation.html) official site.

To access from terminal:

  * alias Phoneapp.PairEng
  * Then pass number using PairEng.generate_pairs(<number>)

To Do's:

  * Add test cases to the application.

Thought process:

  * The number is to have multiple pairs, the pairs to be mapped from dictionary file.
  * Loading file and making the dictionary was an expensive operation, and loosing the 
    `keys` as `numbers` and `values` as `word`. The loosing of word happend due to
    multiple word can map to same number.
  * To overcome the expensive operation, I have used table to store map data, so that
    creating maps from dictionary can be avoided.
  * Now to solve the issue with loosing data from dictionary I have made the map to 
    use word as the key and to the value of this key to have map of number and word.
  * The idea behind the map was to utilize fast operation of fetching value to the 
    key.
  * With using the database to have already processed reduced the time nearly half than
    before.
  * Now first task was to generate pairs, exclusive to only have word length limit to 3,
    for limiting it to have word length, I have updated the script for insert to use only
    word who have length according to the required length.
  * After making the pairs, the task was to get those numbers all possible words list,
    and replace them in the list for the corresponding list number.
  * Doing like this returned list of list containing all the possible words list for the
    number possible pairs.
  * Now next task was to reduce this list to map all the sub-list words, to get paired with
    all other members.
  * For mapping all these words I have implemented reducers to make pairs, which worked
    just fine but the time was getting too much expensive.
  * To resolve with the expensive tasks, I have implemented ETS to use in the app, this
    cache is to start before the application starts up, so have put this to start after the
    application starts up.
  * With using the cache it made possible to achieve the task in time.

