MODULE_NAME="$1"
CLUSTER_NAME="${2:-docker-desktop}"

./.scripts/process.sh "$MODULE_NAME"
./.scripts/deploy-product-chart.sh "$CLUSTER_NAME"
