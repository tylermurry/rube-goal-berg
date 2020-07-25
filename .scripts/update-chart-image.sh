MODULE_NAME="$1"
IMAGE="$2"
CHART_VALUES_FILE="./charts/charts/$MODULE_NAME/values.yaml"

yq write $CHART_VALUES_FILE "image" "$IMAGE" > $CHART_VALUES_FILE

echo "🔵 Updated $MODULE_NAME image to $IMAGE"
