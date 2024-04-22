
gcloud config set compute/zone us-east1-d

git clone https://github.com/GoogleCloudPlatform/opentsdb-bigtable.git

cd opentsdb-bigtable

export BIGTABLE_INSTANCE_ID=bt-opentsdb
export ZONE=us-east1-d

gcloud bigtable instances create ${BIGTABLE_INSTANCE_ID} \
    --cluster-config=id=${BIGTABLE_INSTANCE_ID}-${ZONE},zone=${ZONE},nodes=1 \
    --display-name=OpenTSDB


gcloud container clusters create opentsdb-cluster \
--zone=us-east1-d \
--machine-type e2-standard-4 \
--scopes "https://www.googleapis.com/auth/cloud-platform"

export PROJECT_ID=$(gcloud config get project)
export REGION=us-east1
export AR_REPO=opentsdb-bt-repo
export BIGTABLE_INSTANCE_ID=bt-opentsdb
export ZONE=us-east1-d

gcloud artifacts repositories create ${AR_REPO} \
    --repository-format=docker  \
    --location=${REGION} \
    --description="OpenTSDB on bigtable container images"

export SERVER_IMAGE_NAME=opentsdb-server-bigtable
export SERVER_IMAGE_TAG=2.4.1

gcloud builds submit \
    --tag ${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${SERVER_IMAGE_NAME}:${SERVER_IMAGE_TAG} \
    build

export GEN_IMAGE_NAME=opentsdb-timeseries-generate
export GEN_IMAGE_TAG=0.1

cd generate-ts
./build-cloud.sh
cd ..

envsubst < configmaps/opentsdb-config.yaml.tpl | kubectl create -f -

envsubst < jobs/opentsdb-init.yaml.tpl | kubectl create -f -

kubectl describe jobs


OPENTSDB_INIT_POD=$(kubectl get pods --selector=job-name=opentsdb-init \
                    --output=jsonpath={.items..metadata.name})
kubectl logs $OPENTSDB_INIT_POD

envsubst < deployments/opentsdb-write.yaml.tpl | kubectl create -f  -

envsubst < deployments/opentsdb-read.yaml.tpl | kubectl create -f  -

kubectl get pods

kubectl create -f services/opentsdb-write.yaml

kubectl create -f services/opentsdb-read.yaml

kubectl get services

envsubst < deployments/generate.yaml.tpl | kubectl create -f -

kubectl create -f configmaps/grafana.yaml

kubectl get configmaps

kubectl create -f deployments/grafana.yaml

kubectl get deployments

GRAFANA_PODS=$(kubectl get pods --selector=app=grafana \
               --output=jsonpath={.items..metadata.name})
kubectl port-forward $GRAFANA_PODS 8080:3000


