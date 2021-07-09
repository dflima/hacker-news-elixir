defmodule Hackernews.StorageTest do
  use ExUnit.Case, async: true

  describe "init/1" do
    test "initializes with empty list" do
      assert {:ok, []} == HackerNews.Storage.init(:unused)
    end
  end

  describe "store/1" do
    test "should store an item in the state" do
      [story] = get_stories(1)

      {:ok, pid} = HackerNews.Storage.start_link(name: :storage_server)
      HackerNews.Storage.store(pid, story)

      assert [story] == :sys.get_state(pid)
    end

    test "should erase previous items when the state reaches max_storage" do
      {:ok, pid} = HackerNews.Storage.start_link(name: :storage_server)

      stories = get_stories(51)
      last_story = List.last(stories)

      stories
      |> Enum.each(&HackerNews.Storage.store(pid, &1))

      assert [last_story] == :sys.get_state(pid)
    end
  end

  describe "get_all/0" do
    test "should return empty map as default" do
      {:ok, pid} = HackerNews.Storage.start_link(name: :storage_server)
      items = HackerNews.Storage.get_all(pid)

      assert 0 == Enum.count(items)
    end
  end

  describe "get/1" do
    test "should return a specific item from the state" do
      {:ok, pid} = HackerNews.Storage.start_link(name: :storage_server)
      [story] = get_stories(1)
      HackerNews.Storage.store(pid, story)

      item = HackerNews.Storage.get(pid, story.id)

      assert item == story
    end
  end

  defp get_stories(quantity) do
    1..quantity
    |> Enum.map(fn _ ->
      %{
        by: "Osiris30",
        descendants: 82,
        id: 27_775_927,
        kids: [
          27_776_471,
          27_780_009,
          27_777_712,
          27_776_367,
          27_776_475,
          27_778_925,
          27_776_786,
          27_777_670,
          27_776_361,
          27_777_665,
          27_776_439
        ],
        score: 125,
        time: 1_625_768_652,
        title: "Why geothermal isn't ubiquitous and how it might get that way",
        type: "story",
        url: "https://austinvernon.eth.link/blog/geothermal.html"
      }
    end)
  end
end
