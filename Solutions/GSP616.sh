export REGION=europe-west4
export PROJECT="$DEVSHELL_PROJECT_ID"

terraform -v

git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/other/terraform-codelab/lab-networking

//Replace your PROJECT ID 

cat > terraform.tfvars <<EOF_END
project_id="$PROJECT"
EOF_END

gcloud iam service-accounts create terraform --display-name terraform

gcloud iam service-accounts list
//copy service email from previous command

//gcloud iam service-accounts keys create ./credentials.json --iam-account <service account email>

//REPLACE SERVICE ACCOUNT EMAIL

gcloud iam service-accounts keys create ./credentials.json --iam-account terraform@qwiklabs-gcp-03-8dca2649c476.iam.gserviceaccount.com


//gcloud projects add-iam-policy-binding <my project id> --member=serviceAccount:<service account email> --role=roles/owner

gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:terraform@qwiklabs-gcp-03-8dca2649c476.iam.gserviceaccount.com --role=roles/owner

//gsutil mb gs://<my project id>-state-bucket

gsutil mb gs://$PROJECT-state-bucket


cat > backend.tf <<EOF_END
terraform {
  backend "gcs" {
    bucket = "$PROJECT-state-bucket"       # Change this to <my project id>-state-bucket
    prefix = "terraform/lab/network"
  }
}
EOF_END

terraform init

terraform plan

terraform apply

terraform show


edit network.tf
terraform apply

edit firewall.tf
terraform apply

edit outputs.tf
terraform apply


gcloud compute instances create build-instance --zone=europe-west4-a --machine-type=e2-standard-2 --subnet=my-first-subnet --network-tier=PREMIUM --maintenance-policy=MIGRATE --image=debian-10-buster-v20221206 --image-project=debian-cloud --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=build-instance-1 --tags=allow-ssh

gcloud compute ssh build-instance --zone=europe-west4-a

sudo apt-get update && sudo apt-get install apache2 -y

exit 


gcloud compute instances stop build-instance --zone=europe-west4-a

gcloud compute images create apache-one \
  --source-disk build-instance \
  --source-disk-zone europe-west4-a \
  --family my-apache-webserver

gcloud compute images describe-from-family my-apache-webserver

#Task 11. Update Terraform config 

cd ../lab-app

cp ../lab-networking/credentials.json .
cp ../lab-networking/terraform.tfvars .

edit backend.tf

edit vm.tf

terraform init
terraform apply







