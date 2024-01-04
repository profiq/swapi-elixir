# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20230612-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.15.7-erlang-26.1.1-debian-bullseye-20230612-slim
#
ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.1.1
ARG DEBIAN_VERSION=bullseye-20230612-slim
ARG NODE_VERSION=20

ARG ELIXIR_BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG YARN_BUILDER_IMAGE="node:${NODE_VERSION}-bullseye-slim"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${YARN_BUILDER_IMAGE} as yarn-builder

WORKDIR /app

COPY /assets/package.json /assets/yarn.lock ./

RUN yarn install --frozen-lockfile

FROM ${ELIXIR_BUILDER_IMAGE} as elixir-builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="dev"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets

COPY --from=yarn-builder /app/node_modules ./assets/node_modules

# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

RUN mix ecto.setup

CMD mix phx.server

EXPOSE 4000/tcp
