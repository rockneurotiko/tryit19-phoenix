defmodule TodoWeb.TodoApiView do
  use TodoWeb, :view

  def render("created.json", %{todo: todo}) do
    todo_json(todo)
  end

  @todo_params [:id, :title, :finished]
  defp todo_json(todo) do
    Map.take(todo, @todo_params)
  end
end
