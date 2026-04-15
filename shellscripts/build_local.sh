#!/bin/bash

echo "building local"

EDITION=$1
if [ -z "$EDITION" ]; then
  echo "no edition provided, please add 'full' or 'typo' as argument"
  # stop build
  exit 1
fi

# export env variables
source .secret.env

# TS build
pnpm install
pnpm run build

# fetch data
uv run ./shellscripts/fetch_data.sh
# split xml into pages
## Jerusalem Konvolut
uv run ./shellscripts/split_milestone_gesamt.sh
# New
uv run ./shellscripts/split_milestone_gesamt_2.sh
# build static html files
if [ "$EDITION" = "full" ]; then
  echo "building full edition"
  ant build-full-edition
elif [ "$EDITION" = "typo" ]; then
  echo "building typo edition"
  ant build-edition-typo
else
  echo "invalid edition provided, please add 'full' or 'typo' as argument"
  # stop build
  exit 1
fi

echo "build complete"
echo "website served at http://localhost:8080/html/index.html"
# run python server
python3 -m http.server 8080
