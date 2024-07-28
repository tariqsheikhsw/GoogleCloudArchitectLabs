

gcloud services enable fitness.googleapis.com

cat > values.json <<EOF_END
{  "name": "$DEVSHELL_PROJECT_ID-bucket",
   "location": "us",
   "storageClass": "multi_regional"
}
EOF_END


OAUTH2_TOKEN=$(gcloud auth print-access-token)
export PROJECT_ID=$(gcloud config get-value project)
curl -X POST --data-binary @values.json \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.googleapis.com/storage/v1/b?project=$PROJECT_ID"

#TASK 5


wget https://github.com/tariqsheikhsw/GoogleCloudArchitectLabs/blob/main/Solutions/GSP294/sign.jpg

mv sign.jpg demo-image.png

export OBJECT==$(realpath demo-image.png)

export BUCKET_NAME=$DEVSHELL_PROJECT_ID-bucket 

curl -X POST --data-binary @$OBJECT \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: image/png" \
    "https://www.googleapis.com/upload/storage/v1/b/$BUCKET_NAME/o?uploadType=media&name=demo-image"
