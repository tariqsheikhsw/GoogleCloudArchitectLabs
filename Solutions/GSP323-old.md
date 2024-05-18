 ### GSP323 : Prepare Data for ML APIs on Google Cloud: Challenge Lab : TRY AGAIN  (Task2 , Task3)


 

```
export DATASET_NAME=lab_846

export BigQuery_output_table=qwiklabs-gcp-04-89f5d8b33acf:lab_846.customers_588

export BUCKET_NAME=qwiklabs-gcp-04-89f5d8b33acf-marking

export REGION=us-east1

export TABLE_NAME=customers_588

export TASK_3_BUCKET_NAME=gs://qwiklabs-gcp-04-89f5d8b33acf-marking/task3-gcs-128.result

export TASK_4_BUCKET_NAME=gs://qwiklabs-gcp-04-89f5d8b33acf-marking/task4-cnl-536.result

```

```
cat << EOF > s.py
input_string = "$BigQuery_output_table"
parts = input_string.split(':')
LAB_NAME = parts[1].split('.')[0]
CUSTOMERS = parts[1].split('.')[1]
print("LAB_NAME:", LAB_NAME)
print("CUSTOMERS:", CUSTOMERS)
EOF
output=$(python s.py)
LAB_NAME=$(echo "$output" | awk '/LAB_NAME:/ {print $2}')
CUSTOMERS=$(echo "$output" | awk '/CUSTOMERS:/ {print $2}')
bq mk $LAB_NAME
gsutil mb gs://$DEVSHELL_PROJECT_ID-marking/
gsutil cp gs://cloud-training/gsp323/lab.csv  .
gsutil cp gs://cloud-training/gsp323/lab.schema .
gcloud dataflow jobs run Cloudhustler --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_BigQuery --region $REGION --worker-machine-type e2-standard-2 --staging-location gs://$DEVSHELL_PROJECT_ID-marking/temp --parameters javascriptTextTransformGcsPath=gs://cloud-training/gsp323/lab.js,JSONPath=gs://cloud-training/gsp323/lab.schema,javascriptTextTransformFunctionName=transform,outputTable=$BigQuery_output_table,inputFilePattern=gs://cloud-training/gsp323/lab.csv,bigQueryLoadingTemporaryDirectory=gs://$DEVSHELL_PROJECT_ID-marking/bigquery_temp
gcloud dataproc clusters create cluster-b53a --region $REGION --master-machine-type e2-standard-2 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-size 500 --image-version 2.1-debian11 --project $DEVSHELL_PROJECT_ID
```

##


## Now just run the below command and wait on the page.

```
gcloud alpha services api-keys create --display-name="Lab" 
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=Lab")
API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")
```

```
curl -LO https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSP323.sh
sudo chmod +x GSP323.sh
./GSP323.sh
```


###
# ```Lab Completed!!!```

###
