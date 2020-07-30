MODULE_NAME="$1"

./.scripts/local/local-registry.sh start
./.scripts/process.sh "$MODULE_NAME"
./.scripts/verify-product.sh true true
./.scripts/local/local-registry.sh stop
