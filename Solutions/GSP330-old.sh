----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//Commands need to be updated

export PROJECT_ID=qwiklabs-gcp-03-f228bcb69ff3
export CLUSTER_NAME=hello-cluster
export ZONE=europe-west4-b
export REGION=europe-west4
export REPO=my-repository 

gcloud artifacts repositories create $REPO \
    --repository-format=docker \
    --location=$REGION \
    --description="repository"


gcloud beta container --project "$PROJECT_ID" clusters create "$CLUSTER_NAME" --zone "$ZONE" --no-enable-basic-auth --cluster-version latest --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true  --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-autoscaling --min-nodes "2" --max-nodes "6" --location-policy "BALANCED" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "$ZONE"


kubectl create namespace prod	

kubectl create namespace dev



------------------------------------------------------------------------------------------------------------------------------------------------------------------


TASK2:


gcloud source repos create sample-app

git clone https://source.developers.google.com/p/$PROJECT_ID/r/sample-app


cd ~
gsutil cp -r gs://spls/gsp330/sample-app/* sample-app

git init
cd sample-app/
git add .
git commit -m "committed successfully" 
git push -u origin master



git branch dev
git checkout dev
git push -u origin dev


------------------------------------------------------------------------------------------------------------------------------------------------------------------



TASK 4:

COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" .



git add .
git commit -m "committed successfully" 
git push -u origin dev



git checkout master


git add .
git commit -m "committed successfully" 
git push -u origin master



------------------------------------------------------------------------------------------------------------------------------------------------------------------



TASK 5:

git checkout dev


git add .
git commit -m "committed successfully" 
git push -u origin dev



git checkout master


git add .
git commit -m "committed successfully" 
git push -u origin master







------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------
