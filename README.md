# CockroachDB Admin

CockroachDB administration docker images and OpenShift templates.

## WARNING

These images do not yet work with proper certificate authentication. This project is not ready for production deployments.

## Backup to S3

Docker image and OpenShift cron job to back up a CockroachDB database to S3.
See [cockroach-backup](cockroach-backup) for more information.

## Restore from S3

Docker image and OpenShift job to restore a CockroachDB database from S3.
See [cockroach-restore](cockroach-restore) for more information.
