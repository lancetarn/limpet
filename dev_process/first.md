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

