defmodule HackerNews.Storage do
  use GenServer

  @max_storage Application.get_env(:hacker_news, :max_storage)

  def start_link(options \\ []) do
    name = Keyword.get(options, :name, __MODULE__)
    GenServer.start_link(__MODULE__, options, name: name)
  end

  def store(pid \\ __MODULE__, item) do
    GenServer.cast(pid, {:store, item})
  end

  def get_all(pid \\ __MODULE__) do
    GenServer.call(pid, :get_all)
  end

  def get(pid \\ __MODULE__, story_id) do
    GenServer.call(pid, {:get, story_id})
  end

  def init(_options) do
    {:ok, %{}}
  end

  def handle_cast({:store, item}, state) do
    new_state =
      if Enum.count(state) < @max_storage,
        do: Map.put(state, item.id, item),
        else: %{item.id => item}

    {:noreply, new_state}
  end

  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, story_id}, _from, state) do
    {:reply, Map.get(state, story_id), state}
  end
end
