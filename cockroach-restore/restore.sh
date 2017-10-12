#!/bin/bash
set -euo pipefail

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

if [ "${BACKUP_FILE_NAME}" = "latest" ]; then
  BACKUP_FILE_NAME=$(aws s3 ls s3://$S3_BUCKET/$S3_PATH | sort | tail -n 1 | awk '{ print $4 }')
fi
echo "Getting db backup ${BACKUP_FILE_NAME} from S3"

aws s3 cp s3://$S3_BUCKET/$S3_PATH${BACKUP_FILE_NAME} /var/backups/dump.sql.gz
gzip -d /var/backups/dump.sql.gz

if [ "${DROP_DATABASE}" == "yes" ]; then
	echo "Recreating database $COCKROACH_DATABASE"
    RE_CREATE_SQL="DROP DATABASE $COCKROACH_DATABASE CASCADE; CREATE DATABASE $COCKROACH_DATABASE;"
    ./cockroach sql --execute="$RE_CREATE_SQL" $COCKROACH_CONNECTION_OPTS $COCKROACH_EXTRA_FLAGS
fi

echo "Restoring ${BACKUP_FILE_NAME}"

./cockroach sql --database=$COCKROACH_DATABASE $COCKROACH_CONNECTION_OPTS $COCKROACH_EXTRA_FLAGS < /var/backups/dump.sql

echo "Restore complete"
