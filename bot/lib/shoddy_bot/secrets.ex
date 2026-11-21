defmodule ShoddyBot.Secrets do
  @moduledoc """
  Supplies authentication secrets from the application environment.

  The values are set in `config/runtime.exs` from environment variables
  (`TOKEN_SIGNING_SECRET`, `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`,
  `GITHUB_REDIRECT_URI`). `config/dev.exs` and `config/test.exs` hold local
  values for the token signing secret only.
  """
  use AshAuthentication.Secret

  alias ShoddyBot.Accounts.User

  def secret_for([:authentication, :tokens, :signing_secret], User, _opts, _context) do
    Application.fetch_env(:shoddy_bot, :token_signing_secret)
  end

  def secret_for([:authentication, :strategies, :github, key], User, _opts, _context)
      when key in [:client_id, :client_secret, :redirect_uri] do
    github_config(key)
  end

  defp github_config(key) do
    with {:ok, config} <- Application.fetch_env(:shoddy_bot, :github),
         value when is_binary(value) and value != "" <- Keyword.get(config, key) do
      {:ok, value}
    else
      _ -> :error
    end
  end
end
