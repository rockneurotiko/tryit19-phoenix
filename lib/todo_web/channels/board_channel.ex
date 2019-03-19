defmodule TodoWeb.BoardChannel do
  use Phoenix.Channel

  def join("board:" <> board_id, _params, socket) do
    {:ok, socket |> assign(:board, board_id)}
  end

  def notify({event, board, body}) do
    topic = "board:" <> board
    event = to_string(event)

    TodoWeb.Endpoint.broadcast(topic, event, %{body: body})
  end
end
