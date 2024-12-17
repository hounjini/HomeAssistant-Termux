source "$(dirname "${BASH_SOURCE[0]}")/source.env"
IMAGE_VERSION=2.3.2
IMAGE_NAME="ghcr.io/music-assistant/server:$IMAGE_VERSION"
CONTAINER_NAME="music-assistant"

TZ="Europe/Prague"

STORAGE_PATH="$HOME/container_data/$CONTAINER_NAME"
mkdir -p "$STORAGE_PATH"

case $PORT in
  ''|*[!0-9]*) PORT=8095;;
  *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT="8123";;
esac

udocker_check

udocker_prune

udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

if [ -n "$1" ]; then
 udocker_run --entrypoint "ash -c" -p "$PORT:8095" -e LD_PRELOAD="" "$CONTAINER_NAME" "$@"
else
 udocker_run -p "$PORT:8095" \
   --entrypoint "ash -c" \
   -e TZ="$TZ" \
   -e LD_PRELOAD="" \
   -v "$STORAGE_PATH:/data" \
  "$CONTAINER_NAME" \
  "source /app/venv/bin/activate && rm -rf /app/venv/lib/python*/site-packages/hass_client* && pip install hass-client --force && mass"
fi
exit $?
