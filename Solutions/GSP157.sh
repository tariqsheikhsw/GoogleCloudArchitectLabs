#Task1 

gcloud compute instances create www-1 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --zone us-east4-a \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      Code
      EOF"

gcloud compute instances create www-2 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --zone us-east4-a \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      Code
      EOF"


gcloud compute instances create www-3 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --zone europe-west1-d \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      Code
      EOF"


gcloud compute instances create www-4 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --zone europe-west1-d \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      Code
      EOF"

gcloud compute firewall-rules create www-firewall \
    --target-tags http-tag --allow tcp:80

gcloud compute instances list

#Task2 

gcloud compute addresses create lb-ip-cr \
    --ip-version=IPV4 \
    --global

gcloud compute instance-groups unmanaged create us-east4-resources-w --zone us-east4-a

gcloud compute instance-groups unmanaged create europe-west1-resources-w --zone europe-west1-d

gcloud compute instance-groups unmanaged add-instances us-east4-resources-w \
    --instances www-1,www-2 \
    --zone us-east4-a

gcloud compute instance-groups unmanaged add-instances europe-west1-resources-w \
    --instances www-3,www-4 \
    --zone europe-west1-d

gcloud compute health-checks create http http-basic-check

#Task3

gcloud compute instance-groups unmanaged set-named-ports us-east4-resources-w \
    --named-ports http:80 \
    --zone us-east4-a

gcloud compute instance-groups unmanaged set-named-ports europe-west1-resources-w \
    --named-ports http:80 \
    --zone europe-west1-d

gcloud compute backend-services create web-map-backend-service \
    --protocol HTTP \
    --health-checks http-basic-check \
    --global

gcloud compute backend-services add-backend web-map-backend-service \
    --balancing-mode UTILIZATION \
    --max-utilization 0.8 \
    --capacity-scaler 1 \
    --instance-group us-east4-resources-w \
    --instance-group-zone us-east4-a \
    --global

gcloud compute backend-services add-backend web-map-backend-service \
    --balancing-mode UTILIZATION \
    --max-utilization 0.8 \
    --capacity-scaler 1 \
    --instance-group europe-west1-resources-w \
    --instance-group-zone europe-west1-d \
    --global

gcloud compute url-maps create web-map \
    --default-service web-map-backend-service

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map

gcloud compute addresses list

gcloud compute forwarding-rules create http-cr-rule \
    --address [LB_IP_ADDRESS] \
    --global \
    --target-http-proxy http-lb-proxy \
    --ports 80

#Task4

gcloud compute forwarding-rules list

#Task5

gcloud compute firewall-rules create allow-lb-and-healthcheck \
    --source-ranges 130.211.0.0/22,35.191.0.0/16 \
    --target-tags http-tag \
    --allow tcp:80

gcloud compute firewall-rules delete www-firewall

gcloud compute addresses list

gcloud compute instances list

#Task6(Optional)

gcloud compute instances list

gcloud compute instances delete-access-config NAME


