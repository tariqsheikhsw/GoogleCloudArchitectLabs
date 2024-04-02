gcloud config set project qwiklabs-gcp-04-cb0e2b443d06

export INSTANCE_NAME=prd-pln-b73
export ZONE=us-east1-d

curl -LO raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/master/542164f3a00fe5f28e00f1f904dd7c1924d4875b/GSP101.sh


sudo chmod +x GSP101.sh

./GSP101.sh
