defmodule ShoddyBot.Accounts.UserIdentity do
  @moduledoc """
  A sign-in identity from an OAuth provider (GitHub), linked to a user by the
  provider's stable user id rather than by email.
  """
  use Ash.Resource,
    otp_app: :shoddy_bot,
    domain: ShoddyBot.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication.UserIdentity]

  user_identity do
    user_resource ShoddyBot.Accounts.User
  end

  postgres do
    table "user_identities"
    repo ShoddyBot.Repo

    references do
      reference :user, on_delete: :delete
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end
  end
end
