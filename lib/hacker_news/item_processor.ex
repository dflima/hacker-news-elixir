defmodule HackerNews.ItemProcessor do
  use GenServer

  def start_link(options \\ []) do
    client = Keyword.get(options, :client)
    storage = Keyword.get(options, :storage)
    name = Keyword.get(options, :name, __MODULE__)
    GenServer.start_link(__MODULE__, %{client: client, storage: storage}, name: name)
  end

  def process(pid \\ __MODULE__, item_id) when is_integer(item_id) do
    GenServer.cast(pid, {:process, item_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:process, item_id}, %{client: client, storage: storage} = state) do
    with {:ok, %{status: 200, body: item}} <- client.item(item_id) do
      storage.store(item)
    end

    {:noreply, state}
  end
end
