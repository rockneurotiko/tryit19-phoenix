defmodule TodoWeb.TodoApiController do
  use TodoWeb, :controller

  alias Todo.Todo.Store

  def create_task(conn, %{"board_id" => board, "title" => title}) do
    params = %{title: title, board: board}
    todo = Todo.Todo.new(params)

    case Store.save(todo) do
      :ok ->
        notify({:create, board, todo})
        render(conn, "created.json", todo: todo)

      _ ->
        conn |> put_status(500) |> json(%{done: false})
    end
  end

  def toggle_task(conn, %{"board_id" => board, "task_id" => task}) do
    with {:ok, todo} <- Store.get(board, task),
         todo = %{todo | finished: !todo.finished},
         :ok <- Store.save(todo) do
      notify({:toggle, board, todo})
      render(conn, "created.json", todo: todo)
    else
      _ -> conn |> put_status(500) |> json(%{done: false})
    end
  end

  defp notify(event) do
    TodoWeb.BoardChannel.notify(event)
  end
end
