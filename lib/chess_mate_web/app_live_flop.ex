defmodule ChessMateWeb.AppLiveFlop do
  alias Phoenix.LiveView

  def mount_assigns(route, schema, opts \\ []) do
    base_opts = [
      patch_function: &LiveView.push_patch/2
    ]

    LiveFlop.mount_assigns(route, schema, base_opts ++ opts)
  end
end
