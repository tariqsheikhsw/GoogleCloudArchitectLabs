### GSP212 :  VPC Flow Logs - Analyzing Network Traffic 


TASK 1:- 

//Change REGION
```
gcloud compute networks create vpc-net \
    --subnet-mode=custom \
    --bgp-routing-mode=regional 
    

gcloud compute networks subnets create vpc-subnet \
    --network=vpc-net \
    --range=10.1.3.0/24 \
    --region=us-central1
```
//FlowLogs=ON

```
gcloud compute firewall-rules create allow-http-ssh \
	--network=vpc-net \
	--action=ALLOW \
	--rules=tcp:80,tcp:22 \
	--source-ranges=0.0.0.0/0 \
  	--target-tags=http-server
```
//Logs : ON

//Change PROJECT-ID and ZONE
```
gcloud compute instances create web-server \
    --project=qwiklabs-gcp-03-d90b4b4a6756 \
    --zone=us-central1-c \
    --machine-type=e2-micro \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-subnet 
```
//Firewall Rule : HTTP

SSH into VM (web-server )
```
sudo apt-get update

sudo apt-get install apache2 -y

echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html

exit
```


```
//export MY_SERVER=<EXTERNAL_IP>
export MY_SERVER=34.42.54.33

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```

//Task4 (MANUAL)

BigQuery / Sink

 
