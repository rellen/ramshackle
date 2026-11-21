defmodule ShoddyBot.Accounts do
  use Ash.Domain,
    otp_app: :shoddy_bot

  resources do
    resource ShoddyBot.Accounts.Token
    resource ShoddyBot.Accounts.User
    resource ShoddyBot.Accounts.UserIdentity
  end
end
