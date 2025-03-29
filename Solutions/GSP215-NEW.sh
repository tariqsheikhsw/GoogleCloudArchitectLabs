

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION1: ${RESET}" REGION1
read -p "${YELLOW}${BOLD}Enter the REGION2: ${RESET}" REGION2
read -p "${YELLOW}${BOLD}Enter the VM_ZONE: ${RESET}" VM_ZONE

# Export variables after collecting input
export REGION1 REGION2 VM_ZONE

gcloud compute firewall-rules create default-allow-http --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --priority=1000 --network=default --source-ranges=0.0.0.0/0 --target-tags=http-server --action=ALLOW --rules=tcp:80 && gcloud compute firewall-rules create default-allow-health-check --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --priority=1000 --network=default --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=http-server --action=ALLOW --rules=tcp


gcloud compute instance-templates create $REGION1-template --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --region=$REGION1 --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=$REGION1-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230629,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any && gcloud compute instance-templates create $REGION2-template --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --region=$REGION2 --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=$REGION2-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230629,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any


gcloud beta compute instance-groups managed create $REGION1-mig --project=$DEVSHELL_PROJECT_ID --base-instance-name=$REGION1-mig --size=1 --template=$REGION1-template --region=$REGION1 --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling $REGION1-mig --project=$DEVSHELL_PROJECT_ID --region=$REGION1 --cool-down-period=45 --max-num-replicas=2 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8



gcloud beta compute instance-groups managed create $REGION2-mig --project=$DEVSHELL_PROJECT_ID --base-instance-name=$REGION2-mig --size=1 --template=$REGION2-template --region=$REGION2 --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling $REGION2-mig --project=$DEVSHELL_PROJECT_ID --region=$REGION2 --cool-down-period=45 --max-num-replicas=2 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8



DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

TOKEN=$(gcloud auth application-default print-access-token)

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "checkIntervalSec": 5,
    "description": "",
    "healthyThreshold": 2,
    "logConfig": {
      "enable": false
    },
    "name": "http-health-check",
    "tcpHealthCheck": {
      "port": 80,
      "proxyHeader": "NONE"
    },
    "timeoutSec": 5,
    "type": "TCP",
    "unhealthyThreshold": 2
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/healthChecks"

sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "backends": [
      {
        "balancingMode": "RATE",
        "capacityScaler": 1,
        "group": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION1"'/instanceGroups/'"$REGION1-mig"'",
        "maxRatePerInstance": 50
      },
      {
        "balancingMode": "UTILIZATION",
        "capacityScaler": 1,
        "group": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION2"'/instanceGroups/'"$REGION2-mig"'",
        "maxRatePerInstance": 80,
        "maxUtilization": 0.8
      }
    ],
    "cdnPolicy": {
      "cacheKeyPolicy": {
        "includeHost": true,
        "includeProtocol": true,
        "includeQueryString": true
      },
      "cacheMode": "CACHE_ALL_STATIC",
      "clientTtl": 3600,
      "defaultTtl": 3600,
      "maxTtl": 86400,
      "negativeCaching": false,
      "serveWhileStale": 0
    },
    "compressionMode": "DISABLED",
    "connectionDraining": {
      "drainingTimeoutSec": 300
    },
    "description": "",
    "enableCDN": true,
    "healthChecks": [
      "projects/'"$DEVSHELL_PROJECT_ID"'/global/healthChecks/http-health-check"
    ],
    "loadBalancingScheme": "EXTERNAL",
    "logConfig": {
      "enable": true,
      "sampleRate": 1
    },
    "name": "http-backend"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendServices"


sleep 60

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "defaultService": "projects/'"$DEVSHELL_PROJECT_ID"'/global/backendServices/http-backend",
    "name": "http-lb"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/urlMaps"

sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "http-lb-target-proxy",
    "urlMap": "projects/'"$DEVSHELL_PROJECT_ID"'/global/urlMaps/http-lb"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/targetHttpProxies"

sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "IPProtocol": "TCP",
    "ipVersion": "IPV4",
    "loadBalancingScheme": "EXTERNAL",
    "name": "http-lb-forwarding-rule",
    "networkTier": "PREMIUM",
    "portRange": "80",
    "target": "projects/'"$DEVSHELL_PROJECT_ID"'/global/targetHttpProxies/http-lb-target-proxy"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/forwardingRules"

sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "http-lb-target-proxy-2",
    "urlMap": "projects/'"$DEVSHELL_PROJECT_ID"'/global/urlMaps/http-lb"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/targetHttpProxies"


sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "IPProtocol": "TCP",
    "ipVersion": "IPV6",
    "loadBalancingScheme": "EXTERNAL",
    "name": "http-lb-forwarding-rule-2",
    "networkTier": "PREMIUM",
    "portRange": "80",
    "target": "projects/'"$DEVSHELL_PROJECT_ID"'/global/targetHttpProxies/http-lb-target-proxy-2"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/forwardingRules"


sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "namedPorts": [
      {
        "name": "http",
        "port": 80
      }
    ]
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/regions/$REGION2/instanceGroups/$INSTANCE_NAME_2/setNamedPorts"

sleep 30

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "namedPorts": [
      {
        "name": "http",
        "port": 80
      }
    ]
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/regions/$REGION1/instanceGroups/$INSTANCE_NAME/setNamedPorts"

gcloud compute instances create siege-vm --project=$DEVSHELL_PROJECT_ID --zone=$VM_ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=siege-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230629,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-c/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

sleep 60

export EXTERNAL_IP=$(gcloud compute instances  describe siege-vm --zone=$VM_ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")


sleep 30

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
  -d '{
    "adaptiveProtectionConfig": {
      "layer7DdosDefenseConfig": {
        "enable": false
      }
    },
    "description": "",
    "name": "denylist-siege",
    "rules": [
      {
        "action": "deny(403)",
        "description": "",
        "match": {
          "config": {
            "srcIpRanges": [
               "'"${EXTERNAL_IP}"'"
            ]
          },
          "versionedExpr": "SRC_IPS_V1"
        },
        "preview": false,
        "priority": 1000
      },
      {
        "action": "allow",
        "description": "Default rule, higher priority overrides it",
        "match": {
          "config": {
            "srcIpRanges": [
              "*"
            ]
          },
          "versionedExpr": "SRC_IPS_V1"
        },
        "preview": false,
        "priority": 2147483647
      }
    ],
    "type": "CLOUD_ARMOR"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/securityPolicies"


sleep 30

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
  -d "{
    \"securityPolicy\": \"projects/$DEVSHELL_PROJECT_ID/global/securityPolicies/denylist-siege\"
  }" \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendServices/http-backend/setSecurityPolicy"

LB_IP_ADDRESS=$(gcloud compute forwarding-rules describe http-lb-forwarding-rule --global --format="value(IPAddress)")

gcloud compute ssh --zone "$VM_ZONE" "siege-vm" --project "$DEVSHELL_PROJECT_ID" --quiet --command "sudo apt-get -y install siege && export LB_IP=$LB_IP_ADDRESS && siege -c 150 -t 120s http://\$LB_IP"

