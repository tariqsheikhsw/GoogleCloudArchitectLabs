clear

#!/bin/bash
# Define color variables

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

#---------------------------------------------------- START --------------------------------------------------#

echo -e "${BG_MAGENTA}${BOLD}Starting Execution...${RESET}"

# Step 1: Export Project ID and Project Number
echo -e "${CYAN}${BOLD}Retrieving Project ID and Project Number...${RESET}"
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")

# Step 2: Get the zone from gcloud
echo -e "${CYAN}${BOLD}Retrieving the zone...${RESET}"
export ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

# Step 3: Enable IAP API
echo -e "${YELLOW}${BOLD}Enabling IAP API...${RESET}"
gcloud services enable iap.googleapis.com

# Step 4: Create Linux VM with IAP
echo -e "${GREEN}${BOLD}Creating Linux IAP instance...${RESET}"
gcloud compute instances create linux-iap \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --network-interface=stack-type=IPV4_ONLY,subnet=default,no-address

# Step 5: Create Windows VM with IAP
echo -e "${GREEN}${BOLD}Creating Windows IAP instance...${RESET}"
gcloud compute instances create windows-iap \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --network-interface=stack-type=IPV4_ONLY,subnet=default,no-address \
    --create-disk=auto-delete=yes,boot=yes,device-name=windows-iap,image=projects/windows-cloud/global/images/windows-server-2016-dc-v20240313,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-standard \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

# Step 6: Create Windows Connectivity VM with IAP
echo -e "${GREEN}${BOLD}Creating Windows Connectivity IAP instance...${RESET}"
gcloud compute instances create windows-connectivity \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --create-disk=auto-delete=yes,boot=yes,device-name=windows-connectivity,image=projects/qwiklabs-resources/global/images/iap-desktop-v001,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-standard \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

# Step 7: Create firewall rule for IAP
echo -e "${BLUE}${BOLD}Creating firewall rule for IAP...${RESET}"
gcloud compute firewall-rules create allow-ingress-from-iap \
  --network default \
  --allow tcp:22,tcp:3389 \
  --source-ranges 35.235.240.0/20

# Step 8: Open Firewall and IAP console URLs
echo -e "${MAGENTA}${BOLD}View Firewall Rule and IAP Settings...${RESET}"
echo -e "Firewall Rule URL: ${BLUE}https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/allow-ingress-from-iap?project=$DEVSHELL_PROJECT_ID${RESET}"
echo -e "IAP Settings URL: ${BLUE}https://console.cloud.google.com/security/iap?tab=ssh-tcp-resources&project=$DEVSHELL_PROJECT_ID${RESET}"

# Blank Line
echo ""

# Step 9: Display the service account
echo -e "${CYAN}${BOLD}Service Account: $PROJECT_NUMBER-compute@developer.gserviceaccount.com${RESET}"

# Adding one blank line
echo -e "\n"

# Function to display a random congratulatory message
function random_congrats() {
    MESSAGES=(
        "${GREEN}Congratulations For Completing The Lab! Keep up the great work!${RESET}"
        "${CYAN}Well done! Your hard work and effort have paid off!${RESET}"
        "${YELLOW}Amazing job! You’ve successfully completed the lab!${RESET}"
        "${BLUE}Outstanding! Your dedication has brought you success!${RESET}"
        "${MAGENTA}Great work! You’re one step closer to mastering this!${RESET}"
        "${RED}Fantastic effort! You’ve earned this achievement!${RESET}"
        "${CYAN}Congratulations! Your persistence has paid off brilliantly!${RESET}"
        "${GREEN}Bravo! You’ve completed the lab with flying colors!${RESET}"
        "${YELLOW}Excellent job! Your commitment is inspiring!${RESET}"
        "${BLUE}You did it! Keep striving for more successes like this!${RESET}"
        "${MAGENTA}Kudos! Your hard work has turned into a great accomplishment!${RESET}"
        "${RED}You’ve smashed it! Completing this lab shows your dedication!${RESET}"
        "${CYAN}Impressive work! You’re making great strides!${RESET}"
        "${GREEN}Well done! This is a big step towards mastering the topic!${RESET}"
        "${YELLOW}You nailed it! Every step you took led you to success!${RESET}"
        "${BLUE}Exceptional work! Keep this momentum going!${RESET}"
    )
    RANDOM_INDEX=$((RANDOM % ${#MESSAGES[@]}))
    echo -e "${BOLD}${MESSAGES[$RANDOM_INDEX]}"
}

cd

remove_files() {
    # Loop through all files in the current directory
    for file in *; do
        # Check if the file name starts with "gsp", "arc", or "shell"
        if [[ "$file" == gsp* || "$file" == arc* || "$file" == shell* ]]; then
            # Check if it's a regular file (not a directory)
            if [[ -f "$file" ]]; then
                # Remove the file and echo the file name
                rm "$file"
                echo "File removed: $file"
            fi
        fi
    done
}

remove_files
