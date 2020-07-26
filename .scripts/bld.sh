PRODUCT_NAME="rgb"

function deploy {
  echo "🔵 Deploying umbrella chart..."
  kubectl create namespace $PRODUCT_NAME
  helm upgrade $PRODUCT_NAME ./charts --install --namespace $PRODUCT_NAME
}

function build {
  local MODULE_NAME="$1"
  local IMAGE="$PRODUCT_NAME-$MODULE_NAME:`uuidgen`"

  echo "🔵 Building Dockerfile for module..."
  docker build -t $IMAGE ./$1

  echo "🔵 Updating module chart with new image..."
  .scripts/update-chart-image.sh $1 $IMAGE
}

if [[ $1 -eq "all" ]]
then
  build 'frontend-web'
  build 'goal-data-service'
  build 'goal-device-service'
  build 'goal-event-processor'
  build 'goal-event-service'
else
  build $1
fi

deploy
