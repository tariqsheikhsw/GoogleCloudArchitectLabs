GSP698 :  Securing Google Cloud with CFT Scorecard 

export GOOGLE_PROJECT=$DEVSHELL_PROJECT_ID
export CAI_BUCKET_NAME=cai-$GOOGLE_PROJECT

gcloud services enable cloudasset.googleapis.com \
    --project $GOOGLE_PROJECT

gcloud beta services identity create --service=cloudasset.googleapis.com --project=$GOOGLE_PROJECT

gcloud projects add-iam-policy-binding ${GOOGLE_PROJECT}  \
   --member=serviceAccount:service-$(gcloud projects list --filter="$GOOGLE_PROJECT" --format="value(PROJECT_NUMBER)")@gcp-sa-cloudasset.iam.gserviceaccount.com \
   --role=roles/storage.admin

git clone https://github.com/forseti-security/policy-library.git

cp policy-library/samples/storage_denylist_public.yaml policy-library/policies/constraints/

gsutil mb -l us-west1 -p $GOOGLE_PROJECT gs://$CAI_BUCKET_NAME


# Export resource data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/resource_inventory.json \
    --content-type=resource \
    --project=$GOOGLE_PROJECT

# Export IAM data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/iam_inventory.json \
    --content-type=iam-policy \
    --project=$GOOGLE_PROJECT

# Export org policy data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/org_policy_inventory.json \
    --content-type=org-policy \
    --project=$GOOGLE_PROJECT

# Export access policy data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/access_policy_inventory.json \
    --content-type=access-policy \
    --project=$GOOGLE_PROJECT


curl -o cft https://storage.googleapis.com/cft-cli/latest/cft-linux-amd64
# make executable
chmod +x cft

./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME

# Add a new policy to blacklist the IAM Owner Role
cat > policy-library/policies/constraints/iam_allowlist_owner.yaml << EOF
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedBindingsConstraintV3
metadata:
  name: allowlist_owner
  annotations:
    description: List any users granted Owner
spec:
  severity: high
  match:
    target: ["organizations/**"]
    exclude: []
  parameters:
    mode: allowlist
    assetType: cloudresourcemanager.googleapis.com/Project
    role: roles/owner
    members:
    - "serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com"
EOF


./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME

export USER_ACCOUNT="$(gcloud config get-value core/account)"
export PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_PROJECT --format="get(projectNumber)")

# Add a new policy to allowlist the IAM Editor Role
cat > policy-library/policies/constraints/iam_identify_outside_editors.yaml << EOF
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedBindingsConstraintV3
metadata:
  name: identify_outside_editors
  annotations:
    description: list any users outside the organization granted Editor
spec:
  severity: high
  match:
    target: ["organizations/**"]
    exclude: []
  parameters:
    mode: allowlist
    assetType: cloudresourcemanager.googleapis.com/Project
    role: roles/editor
    members:
    - "user:$USER_ACCOUNT"
    - "serviceAccount:**$PROJECT_NUMBER**gserviceaccount.com"
    - "serviceAccount:$GOOGLE_PROJECT**gserviceaccount.com"
EOF

./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME


