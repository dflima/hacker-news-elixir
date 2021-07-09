defmodule HackerNews.Storage do
  @moduledoc """
  GenServer to store the HackerNews stories.
  """

  use GenServer

  @max_storage Application.get_env(:hacker_news, :max_storage)

  def start_link(options \\ []) do
    name = Keyword.get(options, :name, __MODULE__)
    GenServer.start_link(__MODULE__, options, name: name)
  end

  @spec store(pid(), Map.t()) :: :ok
  def store(pid \\ __MODULE__, item) do
    GenServer.cast(pid, {:store, item})
  end

  @spec get_all(pid()) :: :ok
  def get_all(pid \\ __MODULE__) do
    GenServer.call(pid, :get_all)
  end

  @spec get(pid(), integer()) :: :ok
  def get(pid \\ __MODULE__, story_id) do
    GenServer.call(pid, {:get, story_id})
  end

  def init(_options) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:store, item}, state) when length(state) < @max_storage do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_cast({:store, item}, _state) do
    {:noreply, [item]}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get, story_id}, _from, state) do
    story = Enum.find(state, fn %{id: id} -> id == story_id end)
    {:reply, story, state}
  end
end
