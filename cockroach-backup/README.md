# Cockroach backup

Back up a CockroachDB database to AWS S3. See the
[CockroachDB SQL Dump](https://www.cockroachlabs.com/docs/stable/sql-dump.html) docs for more info.

## Usage

This image can be run with docker via:

```shell
$ docker run \
  -e AWS_ACCESS_KEY_ID=key-id \
  -e AWS_SECRET_ACCESS_KEY=secret-key \
  -e S3_BUCKET=bucket-name \
  -e COCKROACH_DATABASE=db_name \
  -e COCKROACH_USER=user \
  -e COCKROACH_HOST=localhost \
  outtherelabs/cockroach-backup
```

Or as a scheduled OpenShift cron job via:

```shell
$ oc new-app -f https://raw.githubusercontent.com/OutThereLabs/cockroachdb-admin/master/cockroach-backup/cron-job-template.yaml \
  -p JOB_NAME=job-name \
  -p AWS_ACCESS_KEY_ID=key-id \
  -p AWS_SECRET_ACCESS_KEY=secret-key \
  -p S3_BUCKET=bucket-name \
  -p COCKROACH_DATABASE=db_name \
  -p COCKROACH_USER=user \
  -p COCKROACH_HOST=localhost
```
