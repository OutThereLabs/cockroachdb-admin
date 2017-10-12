FROM cockroachdb/cockroach:v1.1.0

MAINTAINER Julian Tescher "julian@outtherelabs.com"

# Install AWS SDK
RUN apt-get update && apt-get install -y --no-install-recommends \
    python python-pip && \
    pip install awscli && \
    apt-get remove -y python-pip && \
    apt-get clean

ENV COCKROACH_DATABASE=**None** \
    COCKROACH_HOST=**None** \
    COCKROACH_PORT=26257 \
    COCKROACH_USER=**None** \
    COCKROACH_EXTRA_FLAGS='' \
    AWS_DEFAULT_REGION=us-west-2 \
    S3_BUCKET=**None** \
    S3_PATH='backups'

ADD backup.sh backup.sh

ENTRYPOINT ["/cockroach/backup.sh"]
