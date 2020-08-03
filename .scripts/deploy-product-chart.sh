PRODUCT_NAME="rgb"
CONTEXT_NAME="$1"
MONGODB_USERNAME="$2"
MONGODB_PASSWORD="$3"


echo "🔵 Deploying umbrella chart using context $CONTEXT_NAME..."

kubectl config use-context "$CONTEXT_NAME"
kubectl create namespace $PRODUCT_NAME

helm dependency update
helm upgrade $PRODUCT_NAME . --install --atomic --debug --namespace $PRODUCT_NAME \
  --set "mongodb.auth.username=$MONGODB_USERNAME,mongodb.auth.password=$MONGODB_PASSWORD" \
  | sed -n '/USER-SUPPLIED VALUES:/q;p'
