# Thread City

Thread City is a Rails social media app for private, relationship-based sharing. Authenticated users can create posts, interact with a feed, manage profiles, send follow requests, and see content from themselves and accepted follow relationships.

## Highlights

- Implements full account registration, login, password reset, remember-me sessions, and email validation with Devise.
- Models a social graph with pending, accepted, and rejected follow requests, including duplicate-request protection at both the model and database-index level.
- Builds a feed around relationship-aware querying: users see their own posts plus posts from accepted follow relationships, ordered by recency.
- Supports core social interactions including post creation/deletion, comments, like/unlike behavior, public user profiles, and editable profile metadata.
- Includes production-oriented Rails defaults: PostgreSQL, Docker, Kamal deployment configuration, Solid Cache/Queue/Cable adapters, Brakeman, bundler-audit, RuboCop, importmap audit, and GitHub Actions CI.

## Features

- Secure user authentication with Devise registration, login, password recovery, persistent sessions, and protected routes.
- Automatic profile creation on signup, seeded from the user's email address.
- Welcome email delivery through `UserMailer` when a new account is created.
- Editable profile name and bio.
- Post feed where each user can create text posts and delete only their own posts.
- Commenting on posts, with comment deletion scoped to the comment owner.
- Like and unlike interactions with a unique `(user_id, post_id)` constraint to prevent duplicate likes.
- User directory with follow buttons, pending request state, and accepted-follow state.
- Follow request inbox where recipients can accept or reject incoming requests.
- User profile pages that show profile details and that user's posts.
- Faker-powered seed data for local demo accounts, posts, comments, likes, and accepted follow relationships.

## Tech Stack

- Ruby 3.4.6
- Rails 8.1.3
- PostgreSQL with Active Record
- Devise for authentication
- Hotwire-ready Rails stack with Turbo, Stimulus, and importmap
- Propshaft asset pipeline
- Action Mailer with Letter Opener in development
- Solid Cache, Solid Queue, and Solid Cable
- Minitest, Capybara, and Selenium for Rails testing support
- RuboCop Rails Omakase, Brakeman, bundler-audit, and importmap audit for quality and security checks
- Docker and Kamal deployment configuration

## Architecture / Data Model

The application uses standard Rails MVC structure with relational models for social-media behavior:

- `User` authenticates through Devise and owns one `Profile`, many `Post` records, many `Comment` records, many `Like` records, and sent/received `FollowRequest` records.
- `Profile` stores display name and bio for each user.
- `Post` belongs to a user and owns comments and likes.
- `Comment` belongs to both a user and a post.
- `Like` belongs to both a user and a post, with a uniqueness validation and database index that allow one like per user per post.
- `FollowRequest` connects a sender and receiver user with a `pending`, `accepted`, or `rejected` status. Accepted sent requests power the `following` association used by the feed.

Important routes are protected by `ApplicationController#authenticate_user!`. The root route is `posts#index`, which builds a new post form and loads posts for the current user plus accepted follow relationships.

## Repository Structure

```text
.
|-- app/
|   |-- controllers/      # Rails controllers for posts, users, profiles, likes, comments, and follow requests
|   |-- mailers/          # Welcome email delivery
|   |-- models/           # User, Profile, Post, Comment, Like, and FollowRequest domain models
|   `-- views/            # Server-rendered ERB views for the feed, profiles, users, and mailers
|-- config/               # Rails app, routes, database, CI, queue, cache, and deployment configuration
|-- db/
|   |-- migrate/          # Schema migrations for authentication and social graph models
|   |-- schema.rb         # Current PostgreSQL schema
|   `-- seeds.rb          # Faker-backed local demo data
|-- test/                 # Rails test structure for models, controllers, mailers, and fixtures
|-- .github/workflows/    # CI workflow for scans, linting, Rails tests, and system tests
|-- Dockerfile            # Production container build
|-- Gemfile               # Ruby and Rails dependencies
`-- config/deploy.yml     # Kamal deployment configuration
```

## Getting Started

### Prerequisites

- Ruby 3.4.6
- PostgreSQL
- Bundler

### Setup

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
```

The setup script can also install dependencies, prepare the database, clear temporary files, and start the development server:

```bash
bin/setup
```

To reset the database while using the setup script:

```bash
bin/setup --reset
```

### Run Locally

```bash
bin/dev
```

Then open:

```text
http://localhost:3000
```

Seeded users all use this password:

```text
password
```

## Testing / Quality

Run the Rails test suite:

```bash
bin/rails test
```

Run the project CI script locally:

```bash
bin/ci
```

The CI script runs setup, RuboCop, bundler-audit, importmap audit, Brakeman, Rails tests, and seed validation. GitHub Actions also defines separate jobs for Ruby security scanning, JavaScript dependency audit, linting, Rails tests, and system tests against PostgreSQL.

Current test files are present for the main models, controllers, and mailer, but much of the checked-in test coverage is scaffold-level. The most meaningful current quality signal is the configured CI/security toolchain plus the database constraints and model validations around likes, follow requests, and required content.

## Deployment

The repository includes a production Dockerfile and Kamal configuration. The Docker image builds a Rails production runtime, precompiles assets, runs as a non-root user, exposes port 80, and starts the app through Thruster.

Kamal deployment is configured in `config/deploy.yml` with:

- `social_media` service and image names.
- Web server host placeholders.
- `RAILS_MASTER_KEY` secret injection.
- Solid Queue-in-Puma configuration.
- Persistent storage volume mapping for `/rails/storage`.

## Author

Nam Do
