

export PROJECT_ID=$(gcloud config get-value core/project)

gcloud services enable documentai.googleapis.com --project $DEVSHELL_PROJECT_ID


  mkdir ./document-ai-challenge
  gsutil -m cp -r gs://spls/gsp367/* \
    ~/document-ai-challenge/


gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-input-invoices

gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-output-invoices

gsutil mb -c standard -l $REGION -b on gs://$PROJECT_ID-archived-invoices


bq --location=US mk  -d \
 --description "Form Parser Results" \
 ${PROJECT_ID}:invoice_parser_results
 
cd ~/document-ai-challenge/scripts/table-schema
 
bq mk --table \
invoice_parser_results.doc_ai_extracted_entities \
doc_ai_extracted_entities.json



cd ~/document-ai-challenge/scripts


export PROJECT_ID=$(gcloud config get-value core/project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"



sleep 15

#!/bin/bash

deploy_function() {
  gcloud functions deploy process-invoices \
  --region=${REGION} \
  --entry-point=process_invoice \
  --runtime=python310 \
  --service-account=${PROJECT_ID}@appspot.gserviceaccount.com \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --env-vars-file=cloud-functions/process-invoices/.env.yaml \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Deployment Retrying..."
    sleep 10
  fi
done

