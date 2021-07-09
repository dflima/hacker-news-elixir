defmodule HackerNews.Client do
  @moduledoc """
  Module responsible for interfacing with Hacker News API.
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://hacker-news.firebaseio.com/v0")
  plug(Tesla.Middleware.JSON, engine_opts: [keys: :atoms])

  @doc """
  Returns the top 500 stories from HackerNews API.

  # Examples

      iex> HackerNewsClient.top_stories()
      {:ok, %Tesla.Env{}}
  """
  @spec top_stories() :: {:ok, Tesla.Env.t()}
  def top_stories, do: get("/topstories.json")

  @spec item(integer()) :: {:ok, Tesla.Env.t()}
  def item(id), do: get("/item/#{id}.json")
end
