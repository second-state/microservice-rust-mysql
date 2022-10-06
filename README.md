# Lightweight and secure microservice with a database backend

In this repo, we demonstrate a microservice written in Rust, and connected to a MySQL database. It supports CURD operations on a database table via a HTTP service interface. The microservice is compiled into WebAssembly and runs in the WasmEdge Runtime, which is a secure and lightweight alternative to natively compiled Rust apps in Linux containers. The WasmEdge Runtime can be managed and orchestrated by container tools such as the Docker CLI, Podman, as well as almost all flavors of Kubernetes. It also works with microservice management frameworks such as Dapr.

> Everything described in this document is captured in the [GitHub Actions CI workflow](.github/workflows/ci.yml).

## Prerequisites

* Install WasmEdge
* Install Rust
* Install and start MySQL (or TiDB)

You also need to install the `wasm32-wasi` compiler target to your Rust install.

```bash
rustup target add wasm32-wasi
```

## Build

Use the following command to build the microservice. A WebAssembly bytecode file (`wasm` file) will be created.

```bash
cargo build --target wasm32-wasi --release
```

You can run the AOT compiler on the `wasm` file. It could significantly improvement the performance of compute-intensive applications. This microservice, however, is a network intensitive application. Our use of async HTTP networking (Tokio and hyper) and async MySQL connectors are crucial for the performance of this microservice.

```bash
wasmedgec target/wasm32-wasi/release/order_demo_service.wasm order_demo_service.wasm
```

## Run

You can use the `wasmedge` command to run the `wasm` application. It will start the server. Make sure that you pass the MySQL connection string as the env variable to the command. 

```bash
wasmedge --env "DATABASE_URL=mysql://user:passwd@127.0.0.1:3306/mysql" order_demo_service.wasm
```

## Test

Open another terminal, and you can use the `curl` command to interact with the web service.

When the microservice receives a GET request to the `/init` endpoint, it would initialize the database with the `orders` table.

```bash
curl http://localhost:8080/init
```

When the microservice receives a POST request to the `/create_order` endpoint, it would extract the JSON data from the POST body and insert an `Order` record into the database table.
For multiple records, use the `/create_orders` endpoint and POST a JSON array of `Order` objects.

```bash
curl http://localhost:8080/create_orders -X POST -d @orders.json
```

When the microservice receives a GET request to the `/orders` endpoint, it would get all rows from the `orders` table and return the result set in a JSON array in the HTTP response.

```bash
curl http://localhost:8080/orders
```

When the microservice receives a POST request to the `/update_order` endpoint, it would extract the JSON data from the POST body and update the `Order` record in the database table that matches the `order_id` in the input data.

```bash
curl http://localhost:8080/update_order -X POST -d @update_order.json
```

When the microservice receives a GET request to the `/delete_order` endpoint, it would delete the row in the `orders` table that matches the `id` GET parameter.

```bash
curl http://localhost:8080/delete_order?id=2
```

That's it. Feel free to fork this project and use it as a template for your own lightweight microservices!

