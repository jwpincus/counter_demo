defmodule CounterWeb.Counter do
  use CounterWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :val, fn(x) -> x + 1 end)}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, update(socket, :val, fn(x) -> x - 1 end)}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h1 class="text-4xl font-bold text-center"> The count is: <%= @val %> </h1>

    <p class="text-center">
     <.button phx-click="dec">-</.button>
     <.button phx-click="inc">+</.button>
     </p>
     </div>
    """
  end
end
