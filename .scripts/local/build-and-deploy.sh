MODULE_NAME="$1"

./.scripts/process.sh "$MODULE_NAME" false
./.scripts/deploy-product-chart.sh docker-desktop
