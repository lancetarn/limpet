defmodule Limpet.Router do
  use Limpet.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Limpet do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/posts", PostController
    post "/posts/:id", PostController, :update

    resources "/post_maps", PostMapController
  end

  # Other scopes may use custom stacks.
   scope "/api", Limpet do
     pipe_through :api
     resources "/json_posts", JsonPostController, except: [:new, :edit]
     resources "/area_posts", AreaPostsController, except: [:new, :edit]
   end
end
