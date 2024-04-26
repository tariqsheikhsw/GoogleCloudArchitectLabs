GSPYYY :  Cloud Audit Logs 

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil ls

echo "Hello World!" > sample.txt
gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID

gsutil ls gs://$DEVSHELL_PROJECT_ID

gcloud compute networks create mynetwork --subnet-mode=auto

gcloud compute instances create default-us-vm \
--zone=us-east1-d --network=mynetwork \
--machine-type=e2-medium


gsutil rm -r gs://$DEVSHELL_PROJECT_ID



