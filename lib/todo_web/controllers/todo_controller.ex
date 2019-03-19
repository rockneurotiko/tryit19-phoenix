defmodule TodoWeb.TodoController do
  use TodoWeb, :controller

  alias Todo.Todo.Store

  def empty(conn, _params) do
    bid = Todo.Reference.gen_reference()
    path = Routes.todo_path(conn, :board, bid)
    conn |> redirect(to: path)
  end

  def board(conn, %{"board_id" => bid}) do
    todos = Store.board(bid)

    conn |> render("board.html", todos: todos, board: bid)
  end
end
