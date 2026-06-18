# ruby-auth-emails

A Ruby on Rails application demonstrating **email verification** and **password reset** using [Devise](https://github.com/heartcombo/devise) and [Mailtrap](https://mailtrap.io).

New users must verify their email address before accessing protected pages. Password resets are delivered as time-limited emails with secure tokens.

## Features

- User registration with email verification flow
- Confirmation email sent via Mailtrap on sign-up
- `confirmed_at` timestamp set on the user record when the link is clicked
- Unconfirmed users are redirected to sign-in with a "please verify" notice
- Password reset with a Devise-generated, time-limited secure token
- Password reset email delivered via Mailtrap
- HTML **and** plain-text versions of every transactional email
- Protected dashboard route — requires a confirmed, authenticated user

## Architecture

```
Browser → Rails → Devise → ActionMailer
                                ↓
                   development: Mailtrap Sandbox (SMTP)
                   production:  Mailtrap Sending API
```

## Requirements

- Ruby 3.3.6
- Rails 7.2
- SQLite3
- A [Mailtrap](https://mailtrap.io) account (free tier works)

## Setup

```bash
git clone https://github.com/zeeshangulzar/ruby-auth-emails
cd ruby-auth-emails

bundle install

cp .env.example .env
# Edit .env — add your Mailtrap SMTP credentials (see Environment Variables below)

rails db:create db:migrate
rails server
```

Open `http://localhost:3000` in your browser.

## Environment Variables

**Development** — uses Mailtrap Sandbox via SMTP (get from Sandboxes → My Sandbox → Integrations → Ruby on Rails):

| Variable | Description |
|----------|-------------|
| `MAILTRAP_SMTP_USER` | SMTP username from the sandbox integration page |
| `MAILTRAP_SMTP_PASS` | SMTP password from the sandbox integration page |
| `MAILTRAP_FROM_EMAIL` | Sender address shown in emails |

**Production** — uses Mailtrap Sending API (get from Settings → API Tokens, requires a verified domain):

| Variable | Description |
|----------|-------------|
| `MAILTRAP_API_KEY` | API key from Mailtrap → Settings → API Tokens |
| `MAILTRAP_FROM_EMAIL` | Sender address shown in emails |

## Email Flow

### Email Verification

1. User fills in the registration form at `/users/sign_up`
2. Devise generates a `confirmation_token` and saves it on the user record
3. `confirmation_instructions` email is sent via Mailtrap containing a confirmation link
4. User clicks the link → `confirmed_at` is set → user is redirected to sign-in
5. Any sign-in attempt by an unconfirmed user signs them out and shows an alert

### Password Reset

1. User visits `/users/password/new` and submits their email
2. Devise generates a `reset_password_token` (hashed in the database)
3. `reset_password_instructions` email is sent via Mailtrap with a time-limited link
4. User clicks the link → `/users/password/edit` form → enters new password
5. Token expires after 6 hours (configurable in `config/initializers/devise.rb`)

## Key Files

| File | Purpose |
|------|---------|
| `app/models/user.rb` | Devise model with `:confirmable` module |
| `app/views/devise/mailer/confirmation_instructions.html.erb` | HTML confirmation email template |
| `app/views/devise/mailer/confirmation_instructions.text.erb` | Plain-text confirmation email |
| `app/views/devise/mailer/reset_password_instructions.html.erb` | HTML password reset email template |
| `app/views/devise/mailer/reset_password_instructions.text.erb` | Plain-text password reset email |
| `config/initializers/mailtrap.rb` | Activates Mailtrap Sending API in production |
| `config/environments/development.rb` | Configures Mailtrap sandbox SMTP for development |
| `config/initializers/devise.rb` | Devise configuration (token TTL, sender address) |
| `app/controllers/application_controller.rb` | Guards against unconfirmed sign-ins |

## Mailtrap Integration

**Development** uses Mailtrap Sandbox via SMTP — emails are caught in the sandbox inbox without being delivered to real addresses:

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  user_name: ENV["MAILTRAP_SMTP_USER"],
  password:  ENV["MAILTRAP_SMTP_PASS"],
  address:   "sandbox.smtp.mailtrap.io",
  port:      2525,
  authentication: :login
}
```

**Production** uses the Mailtrap Sending API via the official [`mailtrap`](https://github.com/railsware/mailtrap-ruby) gem:

```ruby
# config/initializers/mailtrap.rb
Rails.application.config.action_mailer.delivery_method = :mailtrap
Rails.application.config.action_mailer.mailtrap_settings = {
  api_key: ENV["MAILTRAP_API_KEY"]
}
```

## Running Tests

```bash
bundle exec rspec
```

Tests cover:

- User model validations (email presence, uniqueness)
- `confirmed?` state for confirmed vs unconfirmed users
- Dashboard access control (unauthenticated redirect, authenticated access)
