//Some issues - RECHECK 

Changes to Outputs:
  + network_name = "my-custom-network"
╷
│ Error: Incorrect attribute value type
│ 
│   on .terraform/modules/vpc/modules/subnets/main.tf line 55, in resource "google_compute_subnetwork" "subnetwork":
│   55:   secondary_ip_range = [
│   56:     for i in range(
│   57:       length(
│   58:         contains(
│   59:         keys(var.secondary_ranges), each.value.subnet_name) == true
│   60:         ? var.secondary_ranges[each.value.subnet_name]
│   61:         : []
│   62:     )) :
│   63:     var.secondary_ranges[each.value.subnet_name][i]
│   64:   ]
│     ├────────────────
│     │ each.value.subnet_name is "my-gke-subnet"
│     │ var.secondary_ranges is map of list of object with 3 elements
│ 
│ Inappropriate value for attribute "secondary_ip_range": element 0: attribute "reserved_internal_range" is required.



export PROJECT="$DEVSHELL_PROJECT_ID"

terraform -v

git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/other/terraform-codelab/lab-networking

//Replace your PROJECT ID 

cat > terraform.tfvars <<EOF_END
project_id="$PROJECT"
EOF_END

gcloud iam service-accounts create terraform --display-name terraform

gcloud iam service-accounts list
//copy service email from previous command

//gcloud iam service-accounts keys create ./credentials.json --iam-account <service account email>

//REPLACE SERVICE ACCOUNT EMAIL

gcloud iam service-accounts keys create ./credentials.json --iam-account terraform@qwiklabs-gcp-03-8dca2649c476.iam.gserviceaccount.com


//gcloud projects add-iam-policy-binding <my project id> --member=serviceAccount:<service account email> --role=roles/owner

gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:terraform@qwiklabs-gcp-03-8dca2649c476.iam.gserviceaccount.com --role=roles/owner

//gsutil mb gs://<my project id>-state-bucket

gsutil mb gs://$PROJECT-state-bucket


cat > backend.tf <<EOF_END
terraform {
  backend "gcs" {
    bucket = "$PROJECT-state-bucket"       # Change this to <my project id>-state-bucket
    prefix = "terraform/lab/network"
  }
}
EOF_END

terraform init

terraform plan

terraform apply

terraform show

//adding subnet
    {
      subnet_name   = "my-third-subnet"
      subnet_ip     = "10.10.30.0/24"
      subnet_region = "us-east4"
    },

//add secondary range (can be empty)

   my-third-subnet = []




