PRODUCT_NAME="rgb"
CONTEXT_NAME="$1"

echo "🔵 Deploying umbrella chart using context $CONTEXT_NAME..."

kubectl config use-context "$CONTEXT_NAME"
kubectl create namespace $PRODUCT_NAME

helm upgrade $PRODUCT_NAME . --install --namespace $PRODUCT_NAME
