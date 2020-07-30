COMMAND="${1:-start}"
LOCAL_REGISTRY_NAME="${2:-local-registry}"
LOCAL_REGISTRY_PORT="${3:-5000}"
REGISTRY_IS_RUNNING="$(docker inspect -f '{{.State.Running}}' "$LOCAL_REGISTRY_NAME" 2>/dev/null || true)"

function start {
  echo "🔵 Initializing Local Registry"
  if $REGISTRY_IS_RUNNING; then
    echo "🔵 Starting Local Registry"
    docker run -d --restart=always -p "$LOCAL_REGISTRY_PORT:$LOCAL_REGISTRY_PORT" --name "$LOCAL_REGISTRY_NAME" registry:2
  else
    echo "🔵 Local Registry Already Started"
  fi
}

function stop {
  echo "🔵 Stopping Local Registry"
  if $REGISTRY_IS_RUNNING; then
    docker container stop "$LOCAL_REGISTRY_NAME" && docker container rm -v "$LOCAL_REGISTRY_NAME"
  else
    echo "🔵 No Registry Currently Running"
  fi
}

case $COMMAND in
  "start") start ;;
  "stop") stop ;;
esac
