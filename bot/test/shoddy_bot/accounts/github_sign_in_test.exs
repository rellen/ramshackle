defmodule ShoddyBot.Accounts.GithubSignInTest do
  use ShoddyBot.DataCase, async: true

  alias AshAuthentication.{Info, Strategy}
  alias ShoddyBot.Accounts.{User, UserIdentity}

  # Shaped like the claims Assent's GitHub strategy returns.
  defp user_info(overrides \\ %{}) do
    Map.merge(
      %{
        "sub" => 1_234_567,
        "preferred_username" => "octocat",
        "email" => "octocat@example.com",
        "email_verified" => true
      },
      overrides
    )
  end

  defp oauth_tokens, do: %{"access_token" => "gho_secret", "token_type" => "bearer"}

  defp register(user_info) do
    {:ok, strategy} = Info.strategy(User, :github)

    Strategy.action(strategy, :register, %{
      "user_info" => user_info,
      "oauth_tokens" => oauth_tokens()
    })
  end

  defp identities do
    Ash.read!(UserIdentity, authorize?: false)
  end

  test "registers a new user from a verified GitHub email" do
    assert {:ok, user} = register(user_info())

    assert to_string(user.email) == "octocat@example.com"
    assert user.__metadata__.token

    assert [identity] = identities()
    assert identity.user_id == user.id
    assert identity.strategy == "github"
    assert identity.uid == "1234567"
  end

  test "does not store GitHub's OAuth tokens" do
    assert {:ok, _user} = register(user_info())

    assert [identity] = identities()
    assert is_nil(identity.access_token)
    assert is_nil(identity.refresh_token)
  end

  test "refuses an unverified GitHub email" do
    assert {:error, _} = register(user_info(%{"email_verified" => false}))
    assert [] = Ash.read!(User, authorize?: false)
  end

  test "refuses a GitHub account without an email" do
    assert {:error, _} = register(user_info(%{"email" => nil, "email_verified" => false}))
  end

  test "links GitHub to an existing user with the same verified email" do
    {:ok, first} = register(user_info())

    # Simulate a magic-link user existing first by removing the identity.
    Ash.bulk_destroy!(identities(), :destroy, %{}, authorize?: false, strategy: :stream)

    assert {:ok, user} = register(user_info())
    assert user.id == first.id
  end

  test "a returning GitHub user keeps their account when their GitHub email changes" do
    {:ok, first} = register(user_info())

    assert {:ok, user} = register(user_info(%{"email" => "new@example.com"}))
    assert user.id == first.id
    assert to_string(user.email) == "octocat@example.com"
  end

  test "a different GitHub account with the same email is refused" do
    {:ok, _first} = register(user_info())

    assert {:error, _} = register(user_info(%{"sub" => 7_654_321}))
  end
end
