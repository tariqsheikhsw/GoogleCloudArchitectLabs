echo "export ZONE=us-central1-a" >> ~/.bashrc
echo "export REGION=us-central1" >> ~/.bashrc
echo "export PROJECT_ID=`gcloud config get-value core/project`" >> ~/.bashrc
echo "export BACKUP_PLAN=my-backup-plan" >> ~/.bashrc
source ~/.bashrc
echo "export EXTERNAL_ADDRESS=$(gcloud compute addresses describe app-address --format='value(address)' --region $REGION)" >> ~/.bashrc
source ~/.bashrc

gcloud services enable gkebackup.googleapis.com

gcloud beta container clusters update lab-cluster \
--project=$PROJECT_ID  \
--update-addons=BackupRestore=ENABLED \
--zone=$ZONE

gcloud beta container clusters describe lab-cluster \
--project=$PROJECT_ID  \
--zone=$ZONE | grep -A 1 gkeBackupAgentConfig:


