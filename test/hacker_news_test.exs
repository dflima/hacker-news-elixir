defmodule HackerNewsTest do
  use ExUnit.Case
  doctest HackerNews

  test "greets the world" do
    assert HackerNews.hello() == :world
  end
end
