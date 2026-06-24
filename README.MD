# Dockerfiles

### PHP-FPM

Docker images for PHP-FPM.

#### Supported Versions

- PHP 7.4
- PHP 8.0
- PHP 8.1
- PHP 8.2
- PHP 8.3
- PHP 8.4
- PHP 8.5

### Getting the images

```bash
# PHP 7.4
docker image pull meghsh/php:7.4

# PHP 8.1
docker image pull meghsh/php:8.1

# PHP 8.2
docker image pull meghsh/php:8.2

# PHP 8.3
docker image pull meghsh/php:8.3

# PHP 8.4
docker image pull meghsh/php:8.4

# PHP 8.5
docker image pull meghsh/php:8.5
```

### Using the images

One-off commands

```bash
# PHP 7.4
docker run --rm meghsh/php:7.4 bash -c "php -v"

# PHP 8.0
docker run --rm meghsh/php:8.0 bash -c "php -v"

# PHP 8.2
docker run --rm meghsh/php:8.2 bash -c "php -v"

# PHP 8.3
docker run --rm meghsh/php:8.3 bash -c "php -v"

# PHP 8.4
docker run --rm meghsh/php:8.4 bash -c "php -v"

# PHP 8.5
docker run --rm meghsh/php:8.5 bash -c "php -v"
```

With docker-compose:

```
services:
  php:
    image: "meghsh/php:7.4"
    volumes:
      - "./app:/var/www/html"
```

### Testing Images

Install [Container Structure Test](https://github.com/GoogleContainerTools/container-structure-test) and run the tests:


```bash
container-structure-test test --image meghsh/php:8.2 --config php-structure-test.yaml
```

### Node.js (Alpine)

Docker images for Node.js (Alpine variant), including `yarn`, `pnpm`, and `vite`.

#### Supported Versions

- Node 18
- Node 20
- Node 22
- Node 24
- Node 25

### Getting the images

```bash
# Node 25 (Latest)
docker image pull meghsh/node:25

# Node 22 (LTS)
docker image pull meghsh/node:22
```

### Using the images

One-off commands:

```bash
docker run --rm meghsh/node:25 node -v
docker run --rm meghsh/node:25 yarn -v
docker run --rm meghsh/node:25 pnpm -v
```

With docker-compose:

```yaml
services:
  node:
    image: "meghsh/node:25"
    volumes:
      - "./app:/var/www/html"
    command: npm run dev
```

### Testing Node.js Images

To verify the Node.js image structure and installed tools:

```bash
# Build the image locally (optional, if testing changes)
./node/build.sh

# Run structure tests
container-structure-test test --image meghsh/node:25 --config node-structure-test.yaml
```

### Builder

Build-time image used during deployments to compile applications (Laravel,
Bedrock, Node apps). It is `FROM meghsh/php:<version>` — so it carries the exact
PHP version, full extension set, Composer, and WP-CLI of the runtime image — with
Node.js, `npm`, `yarn`, and `pnpm` layered on top. This lets a single ephemeral
container run `composer install` **and** `npm/yarn/pnpm install` + asset builds,
while the long-running runtime containers stay lean.

#### Supported Versions

Mirrors the PHP images: 7.4, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5.

#### Getting the images

```bash
docker image pull meghsh/builder:8.3
```

#### Using the image

Run as an ephemeral, throwaway build container. Pass `--user` so build artifacts
are written to the bind-mounted release directory with the correct ownership, and
point caches at a writable path:

```bash
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --env HOME=/tmp --env COMPOSER_HOME=/tmp/composer \
  --volume "$PWD":/app --workdir /app \
  meghsh/builder:8.3 bash -c '
    composer install --no-dev --optimize-autoloader --no-interaction
    npm ci && npm run build'
```

Select the tag matching the site's PHP version (`meghsh/builder:8.3`); the right
PHP binary is already the default in that image — no per-binary selection needed.

#### Building

```bash
./builder/build.sh   # requires the matching meghsh/php:<version> tags to exist
```

#### Testing the Builder image

```bash
container-structure-test test --image meghsh/builder:8.3 --config builder-structure-test.yaml
```