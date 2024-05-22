### GSP628 :  Ingesting HL7v2 Data with the Healthcare API 

```
export PROJECT_ID=`gcloud config get-value project`
export REGION=us-east1
export DATASET_ID=dataset1
export FHIR_STORE_ID=fhirstore1
export DICOM_STORE_ID=dicomstore1
export HL7_STORE_ID=hl7v2store1

gcloud pubsub topics create projects/$PROJECT_ID/topics/hl7topic

gcloud pubsub subscriptions create hl7_subscription --topic=hl7topic

gcloud healthcare hl7v2-stores create $HL7_STORE_ID --dataset=$DATASET_ID --location=$REGION --notification-config=pubsub-topic=projects/$PROJECT_ID/topics/hl7topic
```
