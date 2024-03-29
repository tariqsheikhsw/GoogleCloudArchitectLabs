# GoogleCloudArchitectLabs

### Implement Load Balancing on Compute Engine: Challenge Lab

- Challenge scenario

Task 1. Create a project jumphost instance

You will use this instance to perform maintenance for the project.

Requirements:

    - Name the instance .
    - Create the instance in the zone.
    - Use an e2-micro machine type.
    - Use the default image type (Debian Linux).


Task 2. Set up an HTTP load balancer

You will serve the site via nginx web servers, but you want to ensure that the environment is fault-tolerant. Create an HTTP load balancer with a managed instance group of 2 nginx web servers. Use the following code to configure the web servers; the team will replace this with their own configuration later.

cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

Note: There is a limit to the resources you are allowed to create in your project, so do not create more than 2 instances in your managed instance group. If you do, the lab might end and you might be banned. 

You need to:

    - Create an instance template. Don't use the default machine type. Make sure you specify e2-medium as the machine type.
    - Create a managed instance group based on the template.
    - Create a firewall rule named as to allow traffic (80/tcp).
    - Create a health check.
    - Create a backend service and add your instance group as the backend to the backend service group with named port (http:80).
    - Create a URL map, and target the HTTP proxy to route the incoming requests to the default backend service.
    - Create a target HTTP proxy to route requests to your URL map
    - Create a forwarding rule.

Create startup.sh file

#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

1 .Create an instance template :

gcloud compute instance-templates create web-server-template \
--metadata-from-file startup-script=startup.sh \
--network default \
--machine-type ec2-medium \
--region us-east1

//us-east1-c

instance-template-web

2 .Create a managed instance group :

gcloud compute instance-groups managed create web-server-group \
--base-instance-name web-server \
--size 2 \
--template instance-template-web \
--region us-east1 \
--zone=us-east1-c

gcloud beta compute instance-groups managed create web-server-group --project=qwiklabs-gcp-01-c2caa154ddc0 --base-instance-name=web-server-group --size=2 --description=web-server-group --template=projects/qwiklabs-gcp-01-c2caa154ddc0/global/instanceTemplates/web-server-template --zone=us-east1-c --list-managed-instances-results=PAGELESS --no-force-update-on-repair --default-action-on-vm-failure=repair --standby-policy-mode=manual










