defmodule HackerNews.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.HackerNews
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, "stories:get"}, state) do
    stories = HackerNews.Storage.get_all() |> Jason.encode!()
    {:reply, {:json, stories}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
