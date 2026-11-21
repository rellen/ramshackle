# ShoddyBot

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Signing in

People sign in with a magic link sent by email, or with GitHub. Both create
an account on first use. The pages are at `/sign-in`.

In development, magic link emails appear in the mailbox preview at
<http://localhost:4000/dev/mailbox>. GitHub sign-in needs an OAuth app:

1. In GitHub, open Settings, Developer settings, OAuth Apps, and choose
   "New OAuth App". Use one app per environment.
2. Set "Authorization callback URL" to the app's base URL followed by
   `/auth/user/github/callback`, for example
   `http://localhost:4000/auth/user/github/callback`.
3. Generate a client secret, and export the client ID and secret as
   `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` before starting the server.

Without those variables, development still starts and magic links work, but
"Sign in with GitHub" fails.

GitHub sign-in only accepts accounts whose primary email is verified on
GitHub. A GitHub sign-in whose verified email matches an existing account
signs in to that account. ShoddyBot does not keep GitHub's OAuth access token.

## Environment variables

Production reads its configuration from these variables in
`config/runtime.exs`:

| Variable | Required | Purpose |
| --- | --- | --- |
| `DATABASE_URL` | Yes | PostgreSQL connection URL, `ecto://USER:PASS@HOST/DATABASE` |
| `SECRET_KEY_BASE` | Yes | Signs and encrypts cookies. Generate with `mix phx.gen.secret` |
| `TOKEN_SIGNING_SECRET` | Yes | Signs sign-in tokens. Generate with `mix phx.gen.secret` |
| `GITHUB_CLIENT_ID` | Yes | Client ID of the GitHub OAuth app |
| `GITHUB_CLIENT_SECRET` | Yes | Client secret of the GitHub OAuth app |
| `GITHUB_REDIRECT_URI` | No | Base of the auth routes. Defaults to `https://PHX_HOST/auth` |
| `MAIL_FROM` | No | Sender address for sign-in emails. Defaults to `noreply@PHX_HOST` |
| `PHX_HOST` | No | Public host name. Defaults to `example.com` |
| `PORT` | No | HTTP port. Defaults to `4000` |
| `PHX_SERVER` | For releases | Set to start the web server in a release |

In development, `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET` and
`GITHUB_REDIRECT_URI` are read too, and are optional.

Production also needs a real mail adapter for `ShoddyBot.Mailer` in
`config/runtime.exs`. None is configured yet, so magic links cannot be
emailed in production until one is.

Ready to run in production? Please [check our deployment guides](https://phoenix.hexdocs.pm/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://phoenix.hexdocs.pm/overview.html
* Docs: https://phoenix.hexdocs.pm
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
