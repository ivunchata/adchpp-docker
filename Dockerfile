ARG VERSION=3.0.0
FROM debian:buster-slim AS build

RUN apt-get update && \
    apt-get install -y swig python3 scons g++ openssl libreadline-dev libssl-dev

WORKDIR /build
    
# Compile adch++
ARG VERSION
ADD src/adchpp_${VERSION}_source.tar.gz .
RUN cd adchpp_${VERSION}_source && \
    scons mode=release arch=x64 && \
    cp -rf plugins/Script/examples build/release-default-x64/bin/scripts

# Generate certs
WORKDIR /certs
ADD util/generate_certs.sh .
RUN sh generate_certs.sh

###############################################################################

FROM debian:buster-slim

# s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && rm -f /tmp/s6-overlay-amd64.tar.gz

WORKDIR /app

ARG VERSION
COPY --from=build /build/adchpp_${VERSION}_source/build/release-default-x64 /app
COPY --from=build /certs/certs /app/certs

RUN apt-get update && \
    apt-get install -y libssl1.1 && \
    mkdir -p /usr/local/lib/lua/5.1 && \
    cp /app/bin/luadchpp.so /usr/local/lib/lua/5.1/luadchpp.so

ENTRYPOINT ["/init"]

ADD ./util/run.sh .
CMD ["/app/run.sh"]
