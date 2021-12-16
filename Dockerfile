ARG VERSION=3.0.0
FROM debian:buster-slim AS build

RUN apt-get update && \
    apt-get install -y swig python3 scons g++ openssl libreadline-dev libssl-dev

WORKDIR /build
    
# Compile adch++
ARG VERSION
ADD src/adchpp_${VERSION}_source.tar.gz .
RUN cd adchpp_${VERSION}_source && \
    scons mode=release arch=x64

# Generate certs
WORKDIR /certs
ADD util/generate_certs.sh .
RUN sh generate_certs.sh


FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y libssl1.1


WORKDIR /app

ARG VERSION
COPY --from=build /build/adchpp_${VERSION}_source/build/release-default-x64 /app
COPY --from=build /certs/certs /app/certs

CMD ["/app/bin/adchppd", "-c", "/app/config"]
