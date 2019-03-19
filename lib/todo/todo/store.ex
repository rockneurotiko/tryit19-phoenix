defmodule Todo.Todo.Store do
  use GenServer

  alias Todo.Todo

  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_) do
    {:ok, %{todos: %{}}}
  end

  def save(%Todo{} = todo, pid \\ @name) do
    GenServer.call(pid, {:save, todo})
  end

  def get(board_id, todo_id, pid \\ @name) do
    GenServer.call(pid, {:get_todo, board_id, todo_id})
  end

  def board(board_id, pid \\ @name) do
    GenServer.call(pid, {:get_board, board_id})
  end

  @impl true
  def handle_call({:save, todo}, _, state) do
    todos = Map.put(state.todos, todo.id, todo)
    {:reply, :ok, %{state | todos: todos}}
  end

  def handle_call({:get_todo, board_id, todo_id}, _, state) do
    result = fetch_todo(state, board_id, todo_id)
    {:reply, result, state}
  end

  def handle_call({:get_board, board_id}, _, state) do
    todos =
      state.todos
      |> Map.values()
      |> Stream.filter(&(&1.board == board_id))
      |> Enum.sort_by(&todo_sort/1)

    {:reply, todos, state}
  end

  defp todo_sort(todo) do
    d = todo.created_at
    {d.year, d.month, d.day, d.hour, d.minute, d.second}
  end

  defp fetch_todo(state, board_id, todo_id) do
    with {:ok, todo} <- Map.fetch(state.todos, todo_id),
         true <- todo.board == board_id do
      {:ok, todo}
    else
      _ -> {:error, :not_found}
    end
  end
end
