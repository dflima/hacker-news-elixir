defmodule HackerNews.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/stories" do
    response = HackerNews.Storage.get_all() |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  get "/stories/:story_id" do
    story_id = String.to_integer(story_id)
    response = HackerNews.Storage.get(story_id) |> Jason.encode!()
    send_resp(conn, 200, response)
  end

  match _ do
    send_resp(conn, 404, "Nothing to see here.")
  end
end
