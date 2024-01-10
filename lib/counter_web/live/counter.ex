defmodule CounterWeb.Counter do
  use CounterWeb, :live_view
  alias Counter.Count

  @topic "live"

  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(_session, _params, socket) do
    CounterWeb.Endpoint.subscribe(@topic) # subscribe to the channel
    {:ok, assign(socket, :val, Count.value)}
  end

  def handle_event("inc", _value, socket) do
    Count.increment()
    new_state = assign(socket, :val, Count.value)
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("dec", _, socket) do
    Count.decrement() # state is updated
    new_state = assign(socket, :val, Count.value) # assign new value to the socket for this client
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns) # broadcast to all clients
    {:noreply, new_state}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  def render(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="text-4xl font-bold text-center"> Counter: <%= @val %> </h1>
      <.button phx-click="dec" class="w-20 bg-red-500 hover:bg-red-600">-</.button>
      <.button phx-click="inc" class="w-20 bg-green-500 hover:bg-green-600">+</.button>
    </div>
    """
  end
end
