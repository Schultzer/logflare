defmodule LogflareWeb.Auth.VercelAuth do
  @moduledoc """
  What we do when someone signs up and oauth's from the Vercel integration.
  """
  use LogflareWeb, :controller

  alias Logflare.Vercel

  @config Application.get_env(:logflare, __MODULE__)

  def set_oauth_params(%{query_string: query_string} = conn, _params) do
    redirect_uri = "#{@config[:vercel_app_host]}/api/callback?#{query_string}"

    params = %{
      "client_id" => "#{@config[:client_id]}",
      "redirect_uri" => redirect_uri,
      "scope" => "read write",
      "response_type" => "code"
    }

    conn
    |> put_session(:oauth_params, params)
    |> redirect(to: Routes.auth_path(conn, :login))
  end

  def set_oauth_params_v2(conn, %{
        "code" => code,
        "configurationId" => _config_id,
        "next" => redirect_to,
        "teamId" => _team_id
      }) do
    resp = Vercel.Client.get_access_token(code) |> IO.inspect(label: :token)

    params = %{
      "next" => redirect_to
    }

    login(conn, params)
  end

  def set_oauth_params_v2(conn, %{
        "code" => code,
        "configurationId" => _config_id,
        "next" => redirect_to
      }) do
    resp = Vercel.Client.get_access_token(code) |> IO.inspect(label: :token)

    params = %{
      "next" => redirect_to
    }

    login(conn, params)
  end

  defp login(conn, params) do
    conn
    |> put_session(:vercel_setup, params)
    |> redirect(to: Routes.auth_path(conn, :login))
  end
end
