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
RUN yes | mix do deps.get, compile
CMD mix phoenix.start
