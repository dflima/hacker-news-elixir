defmodule HackerNews.Endpoint do
  use Plug.Router

  plug(Plug.Static,
    at: "/",
    from: :hacker_news
  )

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/stories" do
    page = parse_page_param(conn.params)

    response =
      HackerNews.Storage.get_all()
      |> Enum.chunk_every(10)
      |> Enum.at(page)
      |> Jason.encode!()

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

  defp parse_page_param(%{"page" => page}) do
    String.to_integer(page)
  end

  defp parse_page_param(_), do: 1
end
