#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid
rm -f /app/tmp/pids/delayed_job.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
