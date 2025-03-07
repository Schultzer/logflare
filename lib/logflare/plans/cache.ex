defmodule Logflare.Plans.Cache do
  @moduledoc false

  alias Logflare.Plans

  def child_spec(_) do
    %{id: __MODULE__, start: {Cachex, :start_link, [__MODULE__, [stats: false, limit: 100_000]]}}
  end

  def get_plan_by_user(user), do: apply_fun(__ENV__.function, [user])
  def get_plan_by(keyword), do: apply_fun(__ENV__.function, [keyword])

  defp apply_fun(arg1, arg2) do
    Logflare.ContextCache.apply_fun(Plans, arg1, arg2)
  end
end
