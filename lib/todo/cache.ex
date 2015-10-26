defmodule Todo.Cache do
  use GenServer

  def start_link do
    IO.puts "Starting Todo Cache."
    GenServer.start_link(__MODULE__, nil, name: :todo_cache)
  end

  def init(_) do
    {:ok, HashDict.new}
  end

  def server_process(name) do
    case Todo.Server.whereis(name) do
      :undefined ->
        GenServer.call(:todo_cache, {:server_process, name})
      pid -> pid
    end
  end

  def handle_call({:server_process, name}, _, state) do
    todo_server_pid = case Todo.Server.whereis(name) do
      :undefined ->
        {:ok, pid} = Todo.ServerSupervisor.start_child(name)
        pid
      pid -> pid
    end

    {:reply, todo_server_pid, state}
  end
end
