

git clone https://github.com/googlecodelabs/user-authentication-with-iap.git
cd user-authentication-with-iap

cd 1-HelloWorld

cat main.py

gcloud app create --project=$(gcloud config get-value project) --region=us-east4

gcloud app deploy

cat app.yaml
//runtime: python38

gcloud app browse

export AUTH_DOMAIN=$(gcloud config get-value project).uc.r.appspot.com

echo $AUTH_DOMAIN

cd ~/user-authentication-with-iap/2-HelloUser

cat app.yaml
//runtime: python38

gcloud app deploy


