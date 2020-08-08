## -----------------------
## This file is responsible for building the application,
## the docker image and updating the chart image for each module
## -----------------------

PRODUCT_NAME="rgb"
MODULE_NAME="$1"
DOCKERHUB_ACCOUNT="tmurry"
REPOSITORY="${2:-local-registry}"

function updateChartImage {
  local CHART_VALUE_LOCATION="$1"
  local IMAGE_NAME="$2"
  local IMAGE_KEY="$3"

  yq write "$CHART_VALUE_LOCATION" "$IMAGE_KEY" "$IMAGE_NAME" > "new-values.yaml"
  yq merge "new-values.yaml" "$CHART_VALUE_LOCATION" --overwrite > "$CHART_VALUE_LOCATION"
  rm -rf "new-values.yaml"
}

function buildDockerImage {
  local MODULE_NAME=$1
  local DIRECTORY="${2:-$MODULE_NAME}"
  local CHART_VALUE_LOCATION="${3:-./charts/$MODULE_NAME/values.yaml}"
  local IMAGE_KEY="${4:-image}"
  local NAME="$PRODUCT_NAME-$MODULE_NAME:$(uuidgen)"

  case $REPOSITORY in
    "dockerhub") PREFIX="$DOCKERHUB_ACCOUNT" ;;
    "local-registry") PREFIX="localhost:5000" ;;
  esac

  echo "🔵 Building Dockerfile for module..."
  docker build -t "$PREFIX/$NAME" "./$DIRECTORY"

  echo "🔵 Pushing image to $REPOSITORY..."
  docker push "$PREFIX/$NAME"

  echo "🔵 Updating $MODULE_NAME chart image to $NAME..."
  updateChartImage "$CHART_VALUE_LOCATION" "$PREFIX/$NAME" "$IMAGE_KEY"
}

function buildFrontendWeb {
  echo "🔵 Building frontend-web"
  # TODO: Add build steps here

  buildDockerImage "frontend-web"
}

function buildGoalDataService {
  buildDockerImage "goal-data-service"
}

function buildGoalDeviceService {
  buildDockerImage "goal-device-service"
}

function buildGoalEventProcessor {
  buildDockerImage "goal-event-processor"
}

function buildGoalEventService {
  buildDockerImage "goal-event-service"
}

function buildProductTests {
  buildDockerImage "product-functional-tests" "product-tests/functional" "./values.yaml" "functionalTestsImage"
  buildDockerImage "product-non-functional-tests" "product-tests/non-functional" "./values.yaml" "nonFunctionalTestsImage"
}

function buildSensorSimulator {
  buildDockerImage "sensor-simulator"
}

# ---------------------------------------------------------------------------------------------------------------------

MODULES_TO_PROCESS=$1;

case $MODULE_NAME in
"none") ;;
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
product-tests
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
  "product-tests") buildProductTests;;
  "sensor-simulator") buildSensorSimulator;;
  esac

done <<< "$MODULES_TO_PROCESS"
