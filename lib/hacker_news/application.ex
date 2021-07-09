defmodule HackerNews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: HackerNews.Worker.start_link(arg)
      # {HackerNews.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: HackerNews.Endpoint,
        options: [
          port: 4001,
          dispatch: dispatch()
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.HackerNews
      ),
      HackerNews.Storage,
      {HackerNews.ItemProcessor, client: HackerNews.Client, storage: HackerNews.Storage},
      {HackerNews.Polling, client: HackerNews.Client, send_after: 300_000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerNews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/[...]", HackerNews.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {HackerNews.Endpoint, []}}
       ]}
    ]
  end
end
