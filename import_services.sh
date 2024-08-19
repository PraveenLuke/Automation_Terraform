#!/bin/bash

# Array of services and corresponding clusters
services=(
  "QaBackendCluster|QADotnetCronECSService"
  "QaBackendCluster|QADotnetECSService"
  "QaBackendCluster|QANodeCronECSService"
  "QaBackendCluster|QANodeECSService"
  "DevBackendCluster|DevDotnetCronECSService"
  "DevBackendCluster|DevDotnetECSService"
  "DevBackendCluster|DevNodeCronECSService"
  "DevBackendCluster|DevNodeECSService"
)

# Iterate over each service and cluster pair
for service_cluster in "${services[@]}"; do
  # Split the service and cluster using IFS (Internal Field Separator)
  IFS="|" read -r CLUSTER SERVICE <<< "$service_cluster"

  RESOURCE_NAME="aws_ecs_service.services[\"$SERVICE\"]"
  SERVICE_ID="$CLUSTER/$SERVICE"

  echo "Importing $SERVICE in cluster $CLUSTER..."
  terraform import $RESOURCE_NAME $SERVICE_ID
done

echo "Import process completed for all services."