# Transmissions subgraph

## Installation

```
yarn install
```

## Build

Configuration for each chain can be found under config folder

```
yarn prepare:${CHAIN}
yarn codegen
```

## Test

```
yarn test
```


## Deploy

### Locally

** edit docker-compose.yaml to use desired fork url. configured for base-sepolia out of the box **

```
docker compose up
yarn create-local
yarn deploy-local
```

