PRODUCT_NAME="rgb"
CONTEXT_NAME="$1"

echo "🔵 Deploying umbrella chart using context $CONTEXT_NAME..."

kubectl config use-context "$CONTEXT_NAME"
kubectl create namespace $PRODUCT_NAME

helm dependency update
helm upgrade $PRODUCT_NAME . --install --atomic --debug --namespace $PRODUCT_NAME | sed -n '/USER-SUPPLIED VALUES:/q;p'
