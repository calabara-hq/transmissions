#!/bin/bash

CID="QmYqUk9rRrKMNosB9xuDvt8UijZmRZT6h72hNmMDVD8CSE"
GATEWAYS=("https://ipfs.io/ipfs" "https://gateway.pinata.cloud/ipfs" "https://dweb.link/ipfs")

for GATEWAY in "${GATEWAYS[@]}"; do
  echo "Checking $GATEWAY/$CID"
  curl -o /dev/null -s -w "%{http_code}\n" "$GATEWAY/$CID"
done

