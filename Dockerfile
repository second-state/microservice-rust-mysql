# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM rust:1.71 AS buildbase
WORKDIR /src
RUN <<EOT bash
    set -ex
    rustup target add wasm32-wasi
EOT

FROM buildbase AS build
COPY Cargo.toml orders.json update_order.json ./
COPY src ./src
# Build the Wasm binary
RUN cargo build --target wasm32-wasi --release
# This line builds the AOT Wasm binary
RUN cp target/wasm32-wasi/release/order_demo_service.wasm order_demo_service.wasm
RUN chmod a+x order_demo_service.wasm

FROM scratch
ENTRYPOINT [ "/order_demo_service.wasm" ]
COPY --link --from=build /src/order_demo_service.wasm /order_demo_service.wasm
