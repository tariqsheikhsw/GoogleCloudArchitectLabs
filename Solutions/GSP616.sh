
terraform -v

git clone https://github.com/terraform-google-modules/cloud-foundation-training.git

cd cloud-foundation-training/other/terraform-codelab/lab-networking

//Replace your PROJECT ID 

cat > terraform.tfvars <<EOF_END
project_id=qwiklabs-gcp-03-8dca2649c476
EOF_END

