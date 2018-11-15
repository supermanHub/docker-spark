#!/bin/bash

echo "Starting ssh service..."
/usr/sbin/sshd

rc=$?
if [[ $rc != 0 ]]; then
  echo "Failed to start ssh servier! return code: $rc. exit($rc)"
  exec $rc
else
  echo "Start sshd service successfully"
fi

exec "$@"