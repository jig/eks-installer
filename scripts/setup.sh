#!/bin/bash -e

# Cluster ENV Variables
# export CLUSTER_NAME=...
# export CLUSTER_SIZE=...
# export CLUSTER_REGION=...
# export CLUSTER_INSTANCE_TYPE=...
# export CLUSTER_KEY_NAME=...

CLUSTER_NAME="${CLUSTER_NAME:-terraform-eks-demo}"
CLUSTER_SIZE="${CLUSTER_SIZE:-2}"
CLUSTER_REGION="${CLUSTER_REGION:-eu-west-1}"
CLUSTER_INSTANCE_TYPE="${CLUSTER_INSTANCE_TYPE:-m3.medium}"
CLUSTER_KEY_NAME="${CLUSTER_KEY_NAME:-}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../

cd terraform/

# Normal terraform init used by Codefresh
#terraform init

# S3 Bucket ENV Variables
# export BUCKET_NAME=marc-...
# export APPLICATION_NAME=...
# export ENVIRONMENT=...

# Our terraform init in order to initialize the S3 backend config
terraform init -backend-config "bucket=$BUCKET_NAME" \
-backend-config "region=$CLUSTER_REGION" \
-backend-config "key=$APPLICATION_NAME/$ENVIRONMENT/terraform.tfstate"

# try 3 times in case we are stuck waiting for EKS cluster to come up
set +e
N=0
SUCCESS="false"
until [ $N -ge 3 ]; do
  terraform apply -auto-approve \
    -var "cluster-name=${CLUSTER_NAME}" \
    -var "cluster-size=${CLUSTER_SIZE}" \
    -var "cluster-region=${CLUSTER_REGION}" \
    -var "cluster-instance-type=${CLUSTER_INSTANCE_TYPE}" \
    -var "cluster-key-name=${CLUSTER_KEY_NAME}" \
    .
  if [[ "$?" == "0" ]]; then
    SUCCESS="true"
    break
  fi
  N=$[$N+1]
done
set -e

if [[ "$SUCCESS" != "true" ]]; then
    exit 1
fi

terraform output kubeca > ../kubernetes/kubeca.txt
terraform output kubehost > ../kubernetes/kubehost.txt
terraform output kubeconfig > ../kubernetes/kubeconfig.yaml
terraform output config-map-aws-auth > ../kubernetes/config-map-aws-auth.yaml