## -----------------------
## This file is responsible for building the application,
## the docker image and updating the chart image for each module
## -----------------------

PRODUCT_NAME="rgb"
MODULE_NAME="$1"
DOCKERHUB_ACCOUNT="tmurry"
REPOSITORY="${2:-local-registry}"

function updateChartImage {
  local CHART_VALUES_FILE="./charts/$1/values.yaml"
  yq write "$CHART_VALUES_FILE" "image" "$2" > "$CHART_VALUES_FILE"
}

function buildDockerImage {
  local MODULE_NAME=$1
  local NAME="$PRODUCT_NAME-$MODULE_NAME:$(uuidgen)"

  case $REPOSITORY in
    "dockerhub") PREFIX=$DOCKERHUB_ACCOUNT ;;
    "local-registry") PREFIX="localhost:5000" ;;
  esac

  echo "🔵 Building Dockerfile for module..."
  docker build -t "$PREFIX/$NAME" "./$MODULE_NAME"

  echo "🔵 Updating $MODULE_NAME chart image to $NAME..."
  updateChartImage "$MODULE_NAME" "$PREFIX/$NAME"

  echo "🔵 Pushing image to $REPOSITORY..."
  docker push "$PREFIX/$NAME"
}

function buildFrontendWeb {
  echo "🔵 Building frontend-web"
  # TODO: Add build steps here

  buildDockerImage "frontend-web"
}

function buildGoalDataService {
  echo "🔵 Building goal-data-service"
  # TODO: Add build steps here

  buildDockerImage "goal-data-service"
}

function buildGoalDeviceService {
  echo "🔵 Building goal-device-service"
  # TODO: Add build steps here

  buildDockerImage "goal-device-service"
}

function buildGoalEventProcessor {
  echo "🔵 Building goal-event-processor"
  # TODO: Add build steps here

  buildDockerImage "goal-event-processor"
}

function buildGoalEventService {
  echo "🔵 Building goal-event-service"
  # TODO: Add build steps here

  buildDockerImage "goal-event-service"
}

# ---------------------------------------------------------------------------------------------------------------------

MODULES_TO_PROCESS=$1;

case $MODULE_NAME in
"changed")
MODULES_TO_PROCESS=$(git diff --name-only deployed..HEAD | awk -F'/' 'NF!=1{print $1}' | sort -u) ;;
"all")
read -r -d '' MODULES_TO_PROCESS << \
EOM
frontend-web
goal-data-service
goal-device-service
goal-event-processor
goal-event-service
EOM
;;
esac

while IFS= read -r module; do

  case $module in
  "frontend-web") buildFrontendWeb;;
  "goal-data-service") buildGoalDataService;;
  "goal-device-service") buildGoalDeviceService;;
  "goal-event-processor") buildGoalEventProcessor;;
  "goal-event-service") buildGoalEventService;;
  esac

done <<< "$MODULES_TO_PROCESS"
