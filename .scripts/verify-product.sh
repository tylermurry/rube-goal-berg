PRODUCT_NAME="rgb"
CLUSTER_NAME="$PRODUCT_NAME-test-cluster"
LOCAL_REGISTRY_NAME="local-registry"
LOCAL_REGISTRY_PORT="5000"
USE_LOCAL_REGISTRY="${1:-true}"
DELETE_CLUSTER="${2:-false}"

echo "🔵 Linting Product Chart"
helm lint .

echo "🔵 Starting Kind Cluster"
if $USE_LOCAL_REGISTRY; then
  cat << EOF | kind create cluster --name $CLUSTER_NAME --config=-
  kind: Cluster
  apiVersion: kind.x-k8s.io/v1alpha4
  containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:$LOCAL_REGISTRY_PORT"]
      endpoint = ["http://$LOCAL_REGISTRY_NAME:$LOCAL_REGISTRY_PORT"]
EOF

  docker network connect "kind" "$LOCAL_REGISTRY_NAME"
else
  kind create cluster --name $CLUSTER_NAME
fi

echo "🔵 Deploying Chart to Kind Cluster"
./.scripts/deploy-product-chart.sh "kind-$CLUSTER_NAME"

if $DELETE_CLUSTER; then
  echo "🔵 Destroying Kind Cluster"
  kind delete cluster --name $CLUSTER_NAME
fi
