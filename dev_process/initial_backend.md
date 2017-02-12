# Limpet

## Beginnings
I found a library book at the bus stop at Como and 15th, in Minneapolis. It was alone.
Do I take it and return it? What do I hope will happen to it if I leave it? How can I
contact the lessee to let them know I took it and will hopefully save them some
fines by returning it? Maybe there can be an app for that.

Limpet is envisioned to allow users to send messages surrounding specific, arbitrary locations as
well as to corresponding listen on arbitrary geographic regions. We'll find out with the
limits of "arbitrary" are as we go along. This suggests a few features:

### Possible Features
- Anyone can post a message to a location
- Anyone can select a single region in the interface and be shown posts within it
- Keyword search to filter posts in a region
- People can sign up to become users
- Users can save regions on which to listen
- Users can view their past posts


#### Pipe dreams
- Crypto for posts

## Tech
This is a side project, so I'm going to explore some new technologies. At first I will be using
Phoenix with PostgreSQL backing. I'd like to explore elm for the frontend, but I'll stick with
js for now, probably involving mapbox or leaflet and React.

The crux of the app will be storing and searching geospatial data, so digging into postGIS was
my first stop. A post in our app will be a simple point attached to some text. Learning how
to structure that in Postgres and query that in ecto, our elixir database library, seemed
like a good initial step.

- [elixir geo](https://github.com/bryanjos/geo)
- [ecto docs](https://hexdocs.pm/ecto/Ecto.html)
- [phoenix docs](https://hexdocs.pm/phoenix/Phoenix.html)
- [postgis docs](http://postgis.net/)

## The Point
Some quick research points me toward a geo library for elixir that maps postgis types to ecto
types. Let's add it to our project.

{Code snippet from deps addition}

`mix deps.get`

Now we've got the extension. Let's try to provide the Postgrex extensions to ecto

{Code snippet from config}

This all seems good. Let's try to generate a model for our post.

Here's where things go wrong.

    ** (Mix.Config.LoadError) could not load config config/dev.exs
        ** (UndefinedFunctionError) function Ecto.Adapters.Postgres.extensions/0 is undefined (module Ecto.Adapters.Postgres is not available)
        Ecto.Adapters.Postgres.extensions()
        (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6
        (stdlib) erl_eval.erl:470: :erl_eval.expr/5
        (stdlib) erl_eval.erl:878: :erl_eval.expr_list/6
        (stdlib) erl_eval.erl:404: :erl_eval.expr/5
        (stdlib) erl_eval.erl:122: :erl_eval.exprs/5

After much head-scratching, I reached out to the Slack channel for help. I was trying to define the types in
the dev.exs config, which doesn't actually load deps. Moving the `Limpet.PostgresTypes` definition
into `limpet/lib/limpet/repo.ex` solved the problem. Sweet, let's try to save a Post!

Now we need to figure out how to fire up `iex` while loading all of the current project files.
Apparently the canonical elixir way to do it is `iex -S mix`; Phoenix goes a step further and
will let us fire up an interactive session while running a dev server with `iex -S mix phoenix.server`.

After that we just make an ecto changeset with a fresh Post model and insert it.

    lance-air:~/Projekte/limpet$ iex -S mix phoenix.server
    Erlang/OTP 19 [erts-8.2] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

    [info] Running Limpet.Endpoint with Cowboy using http://localhost:4000
    Interactive Elixir (1.4.0) - press Ctrl+C to exit (type h() ENTER for help)
    iex(1)> 28 Jan 21:07:03 - info: compiled 6 files into 2 files, copied 3 in 2.1 sec
    alias Limpet.Post
    Limpet.Post
    iex(2)> ch = Post.changeset(%Post{}, {})
    ** (Ecto.CastError) expected params to be a map, got: `{}`
          (ecto) lib/ecto/changeset.ex:464: Ecto.Changeset.do_cast/7
        (limpet) web/models/post.ex:16: Limpet.Post.changeset/2
    iex(2)> ch = Post.changeset(%Post{}, %{})
    #Ecto.Changeset<action: nil, changes: %{},
     errors: [location: {"can't be blank", [validation: :required]},
      message: {"can't be blank", [validation: :required]}], data: #Limpet.Post<>,
     valid?: false>
    iex(3)> ch = Post.changeset(%Post{}, %{location: %Geo.Point{coordinates: { 40, 45}, srid: 4326}, message: "Foo txt"})
    #Ecto.Changeset<action: nil,
     changes: %{location: %Geo.Point{coordinates: {40, 45}, srid: 4326},
       message: "Foo txt"}, errors: [], data: #Limpet.Post<>, valid?: true>
    iex(4)> Repo.insert(ch)
    ** (UndefinedFunctionError) function Repo.insert/1 is undefined (module Repo is not available)
        Repo.insert(#Ecto.Changeset<action: nil, changes: %{location: %Geo.Point{coordinates: {40, 45}, srid: 4326}, message: "Foo txt"}, errors: [], data: #Limpet.Post<>, valid?: true>)
    iex(4)> Limpet.Repo.insert(ch)
    [debug] QUERY OK db=223.8ms
    INSERT INTO "posts" ("location","message","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" [%Geo.Point{coordinates: {40, 45}, srid: 4326}, "Foo txt", {{2017, 1, 29}, {3, 32, 59, 439088}}, {{2017, 1, 29}, {3, 32, 59, 450297}}]
    {:ok,
     %Limpet.Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, id: 1,
      inserted_at: ~N[2017-01-29 03:32:59.439088],
      location: %Geo.Point{coordinates: {40, 45}, srid: 4326}, message: "Foo txt",
      updated_at: ~N[2017-01-29 03:32:59.450297]}}

And now we have a Post to work with.

Time to figure out how to render it. Before we get fancy with maps and whatnot, I just want to get a listing working.
The /posts route explodes because we have no provision for rendering a Geo.Point into HTML. I'm sure there
is a more elegant way to hook into the framework here, but for now I jam helpers on the view module to
get the latitude and longitude. It turns out that they can also be used for the 'show' template. Great, we
can see the post we stuck in via iex. Now for everyone's favorite part: forms. It's unclear how much I'll want to
do with ajax/front-end frameworks at this point. The less the better, although I do want to play with web sockets
at some point.

Getting everything working with CRUD seemed to be easiest if I created another ecto schema, this time using `embedded_schema`
as I wasn't going to persist anything. This will take form input with string lat/lng and validate it. If we
convert to a valid Geo.Point, we map it over to the real Post and save it. After this I decided to generate API endpoints
with `mix phoenix.gen.json --no-model`. This is actually simpler as I will expect incoming post requests to have json post
body that contains a GeoJSON point in the `location` key.

Now it is time to work with maps, via leaflet.
