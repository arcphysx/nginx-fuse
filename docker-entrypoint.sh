#!/bin/sh

# Start nginx in the background
nginx

# Run gcsfuse in the foreground
gcsfuse --implicit-dirs --foreground -o ro "$BUCKET_NAME" "$DEFAULT_WORKDIR"
