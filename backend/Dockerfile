# backend/Dockerfile

FROM elixir:1.16-alpine

# Install build tools & PostgreSQL client
RUN apk add --no-cache build-base git inotify-tools postgresql-client

WORKDIR /app

# Install Hex/Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files and fetch deps
COPY mix.exs mix.lock ./
COPY config ./config
RUN mix deps.get

# Copy the rest of the app
COPY . .

ENV MIX_ENV=dev
ENV PORT=4000

EXPOSE 4000

# Run DB setup and start server
CMD ["sh", "-c", "mix ecto.create && mix ecto.migrate && mix phx.server"]
