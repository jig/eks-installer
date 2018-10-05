#!/bin/bash -e

CLUSTER_NAME="${CLUSTER_NAME:-terraform-eks-demo}"
CLUSTER_SIZE="${CLUSTER_SIZE:-1}"
CLUSTER_REGION="${CLUSTER_REGION:-us-west-2}"
CLUSTER_INSTANCE_TYPE="${CLUSTER_INSTANCE_TYPE:-m4.large}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../

cd terraform/

# Our terraform init in order to initialize the S3 backend config
terraform init -backend-config "bucket=$BUCKET_NAME" \
-backend-config "region=$CLUSTER_REGION" \
-backend-config "key=$APPLICATION_NAME/$ENVIRONMENT/terraform.tfstate"

terraform destroy -auto-approve \
    -var "cluster-name=${CLUSTER_NAME}" \
    -var "cluster-size=${CLUSTER_SIZE}" \
    -var "cluster-region=${CLUSTER_REGION}" \
    -var "cluster-instance-type=${CLUSTER_INSTANCE_TYPE}" \
    .