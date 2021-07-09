defmodule HackerNews.Polling do
  use GenServer

  @max_storage Application.get_env(:hacker_news, :max_storage)

  def start_link(options \\ []) do
    client = Keyword.get(options, :client)
    send_after = Keyword.get(options, :send_after)
    state = %{client: client, send_after: send_after}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    send(self(), :poll)
    {:ok, state}
  end

  def handle_info(:poll, %{client: client, send_after: send_after} = state) do
    with {:ok, %{status: 200, body: top_stories}} <- client.top_stories() do
      top_stories
      |> Enum.take(@max_storage)
      |> Enum.each(&HackerNews.ItemProcessor.process/1)
    end

    Process.send_after(self(), :poll, send_after)
    {:noreply, state}
  end
end
