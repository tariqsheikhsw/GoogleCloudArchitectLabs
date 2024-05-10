
gcloud auth list

git clone https://github.com/GoogleCloudPlatform/terraform-google-lb-http.git

cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb

rm -rf main.tf

wget https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSP206/main.tf

terraform init 

echo $DEVSHELL_PROJECT_ID | terraform plan 

echo $DEVSHELL_PROJECT_ID | terraform apply -auto-approve


EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo http://${EXTERNAL_IP}
