# Quickstart with Docker

Docker CLI and Docker Desktop now have built-in Wasm / WASI support! Using Docker tools, you can build and start all components of the microservice application with a single command on your own computer without installing any additional software. First, you will need to install a WASI-enabled version of Docker as follows.

```bash
TBD
```

## Build and run

You can build the entire microservice application from Rust source code, and then run the services, including the database server, in a single command.

```bash
docker compose up
```

## CRUD tests

Open another terminal, and you can use the `curl` command to interact with the web service.

When the microservice receives a GET request to the `/init` endpoint, it would initialize the database with the `orders` table.

```bash
docker run --rm --network host curlimages/curl curl http://localhost:8080/init
```

When the microservice receives a POST request to the `/create_order` endpoint, it would extract the JSON data from the POST body and insert an `Order` record into the database table. For multiple records, use the `/create_orders` endpoint and POST a JSON array of `Order` objects.

```bash
cat orders.json | docker run --rm --network host -i curlimages/curl curl http://localhost:8080/create_orders -X POST -d @-
```

When the microservice receives a GET request to the `/orders` endpoint, it would get all rows from the orders table and return the result set in a JSON array in the HTTP response.

```bash
docker run --rm --network host curlimages/curl curl http://localhost:8080/orders
```

When the microservice receives a POST request to the `/update_order` endpoint, it would extract the JSON data from the POST body and update the `Order` record in the database table that matches the `order_id` in the input data.

```bash
cat update_order.json | docker run --rm --network host -i curlimages/curl curl http://localhost:8080/update_order -X POST -d @-
```

When the microservice receives a GET request to the `/delete_order` endpoint, it would delete the row in the `orders` table that matches the `id` GET parameter.

```bash
docker run --rm --network host curlimages/curl curl http://localhost:8080/delete_order?id=2
```

That's it. Feel free to fork this project and use it as a template for your own lightweight microservices!
