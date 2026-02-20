FROM eclipse-temurin:25-jre-alpine AS builder

ARG PLAY_CLI_VERSION

RUN apk update && \
    apk add wget

# Install released Version from artefacts
RUN wget -q "https://github.com/Vacxe/google-play-cli-kt/releases/download/${PLAY_CLI_VERSION}/google-play-cli.tar" && \
    tar -xvf "google-play-cli.tar" -C /opt && \
    rm "google-play-cli.tar"

FROM eclipse-temurin:25-jre-alpine AS app

# copy the cli binaries
COPY --from=builder /opt/google-play-cli /opt/google-play-cli

# soft link the cli to /usr/local/bin and check it works ok
RUN ln -s /opt/google-play-cli/bin/google-play-cli /usr/local/bin/google-play-cli && \
    echo "CLI version:" && google-play-cli version

# set the entrypoint to the cli and default args to `--help`
ENTRYPOINT [ "google-play-cli" ]
CMD [ "--help" ]
