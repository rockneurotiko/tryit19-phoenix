defmodule Todo.Todo do
  alias Todo.Reference

  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          finished: boolean,
          board: String.t(),
          created_at: DateTime.t()
        }

  @derive Jason.Encoder
  defstruct [:id, :title, :board, :created_at, finished: false]

  def new(data) when is_map(data) do
    id = Reference.gen_reference()
    data = Map.merge(data, %{id: id, created_at: DateTime.utc_now()})
    struct(__MODULE__, data)
  end
end
