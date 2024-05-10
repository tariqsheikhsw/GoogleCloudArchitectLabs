#Task1

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

#Task2

gcloud beta container backup-restore backup-plans create $BACKUP_PLAN \
--project=$PROJECT_ID \
--location=$REGION \
--cluster=projects/${PROJECT_ID}/locations/${ZONE}/clusters/lab-cluster \
--all-namespaces \
--include-secrets \
--include-volume-data \
--cron-schedule="10 3 * * *" \
--backup-retain-days=30

gcloud beta container backup-restore backup-plans list \
--project=$PROJECT_ID \
--location=$REGION

gcloud beta container backup-restore backup-plans describe $BACKUP_PLAN \
--project=$PROJECT_ID \
--location=$REGION

#Task3

gcloud container clusters get-credentials lab-cluster \
--zone=$ZONE

echo "EXTERNAL_ADDRESS=${EXTERNAL_ADDRESS}"

#Task4 

# Password for lab only. Change to a strong one in your environment.
YOUR_SECRET_PASSWORD=1234567890
kubectl create secret generic mysql-pass --from-literal=password=${YOUR_SECRET_PASSWORD?}
kubectl apply -f https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
kubectl apply -f https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml

patch_file=/tmp/loadbalancer-patch.yaml
cat <<EOF > ${patch_file}
spec:
  loadBalancerIP: ${EXTERNAL_ADDRESS}
EOF
kubectl patch service/wordpress --patch "$(cat ${patch_file})"

while ! curl --fail --max-time 5 --output /dev/null --show-error --silent http://${EXTERNAL_ADDRESS}; do
  sleep 5
done
echo -e "\nhttp://${EXTERNAL_ADDRESS} is accessible\n"

#Task5

Manual

#Task6 

gcloud beta container backup-restore backups create my-backup1 \
--project=$PROJECT_ID \
--location=$REGION \
--backup-plan=$BACKUP_PLAN \
--wait-for-completion

gcloud beta container backup-restore backups list \
--project=$PROJECT_ID \
--location=$REGION \
--backup-plan=$BACKUP_PLAN

gcloud beta container backup-restore backups describe my-backup1 \
--project=$PROJECT_ID \
--location=$REGION \
--backup-plan=$BACKUP_PLAN

#Task7

kubectl delete secret mysql-pass
kubectl delete -f https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
kubectl delete -f https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml

kubectl get pods

echo -e "\nWordPress URL: http://${EXTERNAL_ADDRESS}\n"

#Task8

gcloud beta container backup-restore restore-plans create my-restore-plan1 \
--project=$PROJECT_ID \
--location=$REGION \
--backup-plan=projects/${PROJECT_ID}/locations/${REGION}/backupPlans/$BACKUP_PLAN \
--cluster=projects/${PROJECT_ID}/locations/${ZONE}/clusters/lab-cluster \
--namespaced-resource-restore-mode=delete-and-restore \
--volume-data-restore-policy=restore-volume-data-from-backup \
--all-namespaces

gcloud beta container backup-restore restore-plans list \
--project=$PROJECT_ID \
--location=$REGION

gcloud beta container backup-restore restore-plans describe my-restore-plan1 \
--project=$PROJECT_ID \
--location=$REGION

#Task9 

gcloud beta container backup-restore restores create my-restore1 \
--project=$PROJECT_ID \
--location=$REGION \
--restore-plan=my-restore-plan1 \
--backup=projects/${PROJECT_ID}/locations/${REGION}/backupPlans/${BACKUP_PLAN}/backups/my-backup1 \
--wait-for-completion

kubectl get pods

echo -e "\nWordPress URL: http://${EXTERNAL_ADDRESS}\n"


