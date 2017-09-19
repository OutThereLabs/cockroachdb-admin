#!/bin/bash
set -euo pipefail

if [ "${AWS_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the AWS_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the AWS_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${COCKROACH_DATABASE}" = "**None**" ]; then
  echo "You need to set the COCKROACH_DATABASE environment variable."
  exit 1
fi

if [ "${COCKROACH_HOST}" = "**None**" ]; then
  echo "You need to set the COCKROACH_HOST environment variable."
  exit 1
fi

if [ "${COCKROACH_USER}" = "**None**" ]; then
  echo "You need to set the COCKROACH_USER environment variable."
  exit 1
fi

COCKROACH_CONNECTION_OPTS="--host $COCKROACH_HOST --port $COCKROACH_PORT --user $COCKROACH_USER"

echo "Creating dump of ${COCKROACH_DATABASE} database from ${COCKROACH_HOST}..."
./cockroach dump $COCKROACH_DATABASE $COCKROACH_CONNECTION_OPTS $COCKROACH_EXTRA_FLAGS | gzip > /var/backups/dump.sql.gz

echo "Uploading dump to $S3_BUCKET"
cat /var/backups/dump.sql.gz | aws s3 cp - s3://$S3_BUCKET/$S3_PATH$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz || exit 2

echo "SQL backup uploaded successfully"
