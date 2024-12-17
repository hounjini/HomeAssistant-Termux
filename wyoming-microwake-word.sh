source "$(dirname "${BASH_SOURCE[0]}")/source.env"
IMAGE_NAME="rhasspy/wyoming-microwakeword:latest"
CONTAINER_NAME="wyoming-microwake-word"

# Set timezone, eg, Asia/Seoul. Feel free to change.
TZ="Europe/Prague"

# Check if PORT is a valid number
case $PORT in
  ''|*[!0-9]*) PORT=10400;;
  *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT="8123";;
esac

udocker_check

udocker_prune

udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

if [ -n "$1" ]; then
 udocker_run --entrypoint "bash -c" -p "$PORT:10400" "$CONTAINER_NAME" "$@"
else
 udocker_run -p "$PORT:10400" \
   -e TZ="$TZ" \
   -e LD_PRELOAD="" \
  "$CONTAINER_NAME"
fi
exit $?
