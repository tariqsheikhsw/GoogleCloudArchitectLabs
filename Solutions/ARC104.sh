
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com


sleep 45

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID



PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$DEVSHELL_PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher


export BUCKET="gs://$DEVSHELL_PROJECT_ID"



mkdir ~/techcps && cd $_
touch index.js && touch package.json


cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');

functions.cloudEvent('eventStorage', (cloudevent) => {
  console.log('A new event in your Cloud Storage bucket has been logged!');
  console.log(cloudevent);
});
EOF


sed -i "3c\functions.cloudEvent('$FUNCTION_NAME', eventStorage => {" index.js


cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF


#!/bin/bash

deploy_function() {
  gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime nodejs16 \
  --entry-point $FUNCTION_NAME \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET \
  --trigger-location $REGION \
  --max-instances 2 --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully ..."
    deploy_success=true
  else
    echo "Trying ..."
    sleep 10
  fi
done



cd ..


mkdir ~/techcps && cd $_
touch index.js && touch package.json



cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.status(200).send('HTTP function (2nd gen) has been called!');
});
EOF


sed -i "3c\functions.http('$FUNCTION_NAME', helloWorld => {" index.js



cat > package.json <<EOF
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF



#!/bin/bash

gcloud functions deploy $HTTP_FUNCTION \
  --gen2 \
  --runtime nodejs16 \
  --entry-point $HTTP_FUNCTION \
  --source . \
  --region $REGION \
  --trigger-http \
  --timeout 600s \
  --max-instances 2 \
  --min-instances 1 --quiet

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully ..."
    deploy_success=true
  else
    echo "Trying ..."
    sleep 10
  fi
done




