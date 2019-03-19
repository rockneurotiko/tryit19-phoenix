defmodule TodoWeb.Router do
  use TodoWeb, :router

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

  scope "/", TodoWeb do
    pipe_through :browser

    get "/", TodoController, :empty
    get "/:board_id", TodoController, :board
  end

  scope "/api", TodoWeb do
    pipe_through :api
    get "/board/:board_id", TodoApiController, :get_board
    post "/board/:board_id/task", TodoApiController, :create_task
    post "/board/:board_id/task/:task_id/toggle", TodoApiController, :toggle_task
  end
end
