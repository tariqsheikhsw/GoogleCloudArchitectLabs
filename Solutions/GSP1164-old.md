### GSP1164 :  Analyzing Findings with Security Command Center 


```
gcloud pubsub topics create export-findings-pubsub-topic

gcloud pubsub subscriptions create export-findings-pubsub-topic-sub --topic export-findings-pubsub-topic
```

//REPLACE ZONE
```
gcloud compute instances create instance-1 --zone=us-east4-a \
--machine-type e2-micro \
--scopes=https://www.googleapis.com/auth/cloud-platform
```

//REPLACE LOCATION
```
PROJECT_ID=$(gcloud config get project)
bq --location=us-east4 --apilog=/dev/null mk --dataset \
$PROJECT_ID:continuous_export_dataset
```

//REPLACE PROJECT-ID (2 places)

```
gcloud services enable securitycenter.googleapis.com
```
```
gcloud scc bqexports create scc-bq-cont-export --dataset=projects/qwiklabs-gcp-04-35bbf77f6a61/datasets/continuous_export_dataset --project=qwiklabs-gcp-04-35bbf77f6a61
```

//REPLACE PROJECT-ID
```
for i in {0..2}; do
gcloud iam service-accounts create sccp-test-sa-$i;
gcloud iam service-accounts keys create /tmp/sa-key-$i.json \
--iam-account=sccp-test-sa-$i@qwiklabs-gcp-04-35bbf77f6a61.iam.gserviceaccount.com;
done
```

```
bq query --apilog=/dev/null --use_legacy_sql=false  \
"SELECT finding_id,event_time,finding.category FROM continuous_export_dataset.findings"
```


