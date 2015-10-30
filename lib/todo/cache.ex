defmodule Todo.Cache do
  def server_process(name) do
    case Todo.Server.whereis_name(name) do
      :undefined -> create_server(name)
      pid        -> pid
    end
  end

  defp create_server(name) do
    case Todo.ServerSupervisor.start_child(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
