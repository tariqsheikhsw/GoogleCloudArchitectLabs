gcloud config set compute/region us-east1

gcloud config get-value compute/region

gcloud config set compute/zone us-east1-b

gcloud config get-value compute/zone

gcloud config get-value project

gcloud compute project-info describe --project $(gcloud config get-value project)

export PROJECT_ID=$(gcloud config get-value project)

export ZONE=$(gcloud config get-value compute/zone)

echo -e "PROJECT ID: $PROJECT_ID\nZONE: $ZONE"

gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE

gcloud compute instances create --help

gcloud -h

gcloud config --help

gcloud help config

gcloud config list

gcloud config list --all

gcloud components list

gcloud compute instances list

gcloud compute instances list --filter="name=('gcelab2')"

gcloud compute firewall-rules list

gcloud compute firewall-rules list --filter="network='default'"

gcloud compute firewall-rules list --filter="NETWORK:'default' AND ALLOW:'icmp'"

gcloud compute ssh gcelab2 --zone $ZONE
(Y)

sudo apt install -y nginx

gcloud compute firewall-rules list

gcloud compute instances add-tags gcelab2 --tags http-server,https-server

gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute firewall-rules list --filter=ALLOW:'80'

curl http://$(gcloud compute instances list --filter=name:gcelab2 --format='value(EXTERNAL_IP)')

gcloud logging logs list

gcloud logging logs list --filter="compute"

gcloud logging read "resource.type=gce_instance" --limit 5

gcloud logging read "resource.type=gce_instance AND labels.instance_name='gcelab2'" --limit 5


