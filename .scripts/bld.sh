PRODUCT_NAME="rgb"
MODULE_NAME="$1"
IMAGE="$PRODUCT_NAME-$MODULE_NAME:`uuidgen`"

echo "🔵 Building Dockerfile for module..."
docker build -t $IMAGE ./$MODULE_NAME

echo "🔵 Updating module chart with new image..."
.scripts/update-chart-image.sh $MODULE_NAME $IMAGE

echo "🔵 Deploying umbrella chart..."
kubectl create namespace $PRODUCT_NAME
helm upgrade $PRODUCT_NAME ./charts --install --namespace $PRODUCT_NAME
