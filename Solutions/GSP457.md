### GSP457 :  Ingesting FHIR Data with the Healthcare API 

#Task1 

```
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export PROJECT_NUMBER=$(gcloud projects list --filter=projectId:$PROJECT_ID \
  --format="value(projectNumber)")
export LOCATION=us-west1
export DATASET_ID=dataset1
export FHIR_STORE_ID=fhirstore1
export TOPIC=fhir-topic
export HL7_STORE_ID=hl7v2store1
```

#Task2   
//Healthcare API

#Task3 
```
bq --location=us-west1 mk --dataset --description HCAPI-dataset $PROJECT_ID:$DATASET_ID

bq --location=us-west1 mk --dataset --description HCAPI-dataset-de-id $PROJECT_ID:de_id

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.jobUser
```
#Task4
```
gcloud healthcare datasets create $DATASET_ID \
--location=$LOCATION
```
#Task5 
//Manual

#Task6
```
gcloud healthcare fhir-stores import gcs $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--gcs-uri=gs://spls/gsp457/fhir_devdays_gcp/fhir1/* \
--content-structure=BUNDLE_PRETTY

gcloud healthcare fhir-stores export bq $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.$DATASET_ID \
--schema-type=analytics


gcloud healthcare fhir-stores export bq de_id \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.de_id \
--schema-type=analytics
```

#Task7  
//Running Queries in BigQuery
```
SELECT
  id AS patient_id,
  name[safe_offset(0)].given AS given_name,
  name[safe_offset(0)].family AS family,
  birthDate AS birth_date
FROM dataset1.Patient LIMIT 10
```

```
SELECT
id AS patient_id,
  name[safe_offset(0)].given AS given_name,
  name[safe_offset(0)].family AS family,
  birthDate AS birth_date
FROM de_id.Patient LIMIT 10
```
