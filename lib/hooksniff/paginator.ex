defmodule HookSniff.Paginator do
  @moduledoc """
  Pagination Helper for HookSniff Elixir SDK.

  Usage:
      HookSniff.Paginator.paginate(fn opts -> HookSniff.Message.list(opts) end, limit: 100)
      |> Enum.each(fn msg -> IO.puts(msg.id) end)
  """

  @doc """
  Auto-paginate through all items using a Stream.
  """
  def paginate(fetch_page, opts \\ []) do
    limit = Keyword.get(opts, :limit)
    iterator = Keyword.get(opts, :iterator)

    Stream.resource(
      fn -> {fetch_page, limit, iterator, false} end,
      fn {fetch_page, limit, iterator, done} ->
        if done do
          {:halt, {fetch_page, limit, iterator, true}}
        else
          page = fetch_page.(%{limit: limit, iterator: iterator})

          items = Map.get(page, :data, [])

          next_done = Map.get(page, :done, true)
          next_iterator = Map.get(page, :iterator)

          if next_done || is_nil(next_iterator) do
            {items, {fetch_page, limit, iterator, true}}
          else
            {items, {fetch_page, limit, next_iterator, false}}
          end
        end
      end,
      fn _ -> :ok end
    )
  end

  @doc """
  Collect all items into a list.
  """
  def to_list(fetch_page, opts \\ []) do
    paginate(fetch_page, opts) |> Enum.to_list()
  end
end
