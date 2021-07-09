defmodule HackerNewsClientTest do
  use ExUnit.Case

  describe "top_stores/0" do
    test "returns the top 500 stories" do
      {:ok, response} = HackerNews.Client.top_stories()

      assert %Tesla.Env{} = response
      assert 200 == response.status
      assert :get == response.method
      assert 500 == Enum.count(response.body)
    end
  end
end
