

gcloud auth list
gcloud services enable datacatalog.googleapis.com bigqueryconnection.googleapis.com

sleep 15

bq mk --dataset ecommerce

export PROJECT_ID=$(gcloud config get-value project)

CP_URI="gs://$PROJECT_ID-bucket/customer-online-sessions.csv"


bq mk --connection --project_id=$PROJECT_ID --location=$REGION --connection_type=CLOUD_RESOURCE customer_data_connection

bq mk --external_table_definition=gs://$PROJECT_ID-bucket/customer-online-sessions.csv ecommerce.customer_online_sessions


cat > techcps.sh <<EOF_CP

#!/bin/bash

GS_URL=\$(bq show --connection \$PROJECT_ID.\$REGION.customer_data_connection | grep "serviceAccountId" | awk '{gsub(/"/, "", \$8); print \$8}')
CP="\${GS_URL%?}"

gcloud projects add-iam-policy-binding \$PROJECT_ID \\
    --member="serviceAccount:\$CP" \\
    --role="roles/storage.objectViewer"

    
EOF_CP


chmod +x techcps.sh && ./techcps.sh


gcloud data-catalog tag-templates create sensitive_data_template --location=$REGION \
    --display-name="Sensitive Data Template" \
    --field=id=has_sensitive_data,display-name="Has Sensitive Data",type=bool \
    --field=id=sensitive_data_type,display-name="Sensitive Data Type",type='enum(Location Info|Contact Info|None)'


echo "------------Click the below link----------------"

echo "Click here to open the link https://console.cloud.google.com/dataplex/search?cloudshell=true&project=$PROJECT_ID"


