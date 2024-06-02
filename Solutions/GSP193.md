### GSP193 :  VPC Network Peering 

//change ZONE and PROJECT ID 1 and ID 2 

### Run in cloudshell 1
```cmd
export PROJECT_ID2=qwiklabs-gcp-03-3c255e1b5ce1
```
```
gcloud compute networks create network-a --subnet-mode custom
gcloud compute networks subnets create network-a-subnet --network network-a \
    --range 10.0.0.0/16 --region us-west1 
gcloud compute instances create vm-a --zone us-west1-c --network network-a --subnet network-a-subnet --machine-type e2-small 
gcloud compute firewall-rules create network-a-fw --network network-a --allow tcp:22,icmp
```
### Open another Cloudshell 2
```cmd
export PROJECT_ID1=qwiklabs-gcp-03-1ef60f7e56f8
```
```cmd
export PROJECT_ID2=qwiklabs-gcp-03-3c255e1b5ce1
```
```cmd
gcloud config set project $PROJECT_ID2
gcloud compute networks create network-b --subnet-mode custom
gcloud compute networks subnets create network-b-subnet --network network-b \
    --range 10.8.0.0/16 --region us-west1 
gcloud compute instances create vm-b --zone us-west1-c --network network-b --subnet network-b-subnet --machine-type e2-small
gcloud compute firewall-rules create network-b-fw --network network-b --allow tcp:22,icmp
gcloud compute networks peerings create peer-ba \
  --network=network-b \
  --peer-project=$PROJECT_ID1 \
  --peer-network=network-a
```
### Run in Cloudshell 1
```cmd
gcloud compute networks peerings create peer-ab \
  --network=network-a \
  --peer-project=$PROJECT_ID2 \
  --peer-network=network-b
```

