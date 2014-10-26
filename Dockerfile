FROM jnijni/elixir-docker

# Copy website
ADD src /src

# Fix mix to stop it from re-downloading hex and rebar
ADD src/mix_base /.mix

# Start website
EXPOSE 8080
ENV PORT 8080
ENV MIX_ENV prod
WORKDIR /src
CMD yes | mix do clean, deps.get && mix phoenix.start
