gcloud services enable dataplex.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud dataplex lakes create customer-engagements --location=$REGION --display-name="Customer Engagements"

gcloud dataplex zones create raw-event-data --location=$REGION --lake=customer-engagements --display-name="Raw Event Data" --type=RAW --discovery-enabled --resource-location-type=SINGLE_REGION

gsutil mb -p $DEVSHELL_PROJECT_ID -c REGIONAL -l $REGION gs://$DEVSHELL_PROJECT_ID/

gcloud dataplex assets create raw-event-files --location=$REGION --lake=customer-engagements --zone=raw-event-data --display-name="Raw Event Files" --resource-name=projects/my-project/buckets/${DEVSHELL_PROJECT_ID} --resource-type=STORAGE_BUCKET
