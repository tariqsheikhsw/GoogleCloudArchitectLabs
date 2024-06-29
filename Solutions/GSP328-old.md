### GSP328 :  Develop Serverless Applications on Cloud Run: Challenge Lab : ReTEST


## Let's start with defining some variables given by Cloud Skill Boosts

```
export PUBLIC_BILLING_SERVICE=
```
```
export FRONTEND_STAGING_SERVICE=
```
```
export PRIVATE_BILLING_SERVICE=
```
```
export BILLING_SERVICE_ACCOUNT=
```
```
export BILLING_PROD_SERVICE=
```
```
export FRONTEND_SERVICE_ACCOUNT=
```
```
export FRONTEND_PRODUCTION_SERVICE=
```

## Prerequisites

1. Setting up basic configuration
```
gcloud config set run/region us-central1
gcloud config set run/platform managed
```
2. Clone the base code for this lab
```
git clone https://github.com/rosera/pet-theory.git && cd pet-theory/lab07
```

## Task - 1 : Deploy a Public Billing Service

1.1 Go to the resource directory
```
cd ~/pet-theory/lab07/unit-api-billing
```
1.2 Build & deploy image for the public billing service
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1
gcloud run deploy $PUBLIC_BILLING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1
```
## Task - 2 : Deploy the Frontend Service

2.1 Go to the resource directory
```
cd ~/pet-theory/lab07/staging-frontend-billing
```
2.2 Build & deploy image for the frontend staging service
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1
gcloud run deploy $FRONTEND_STAGING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1
```

## Task - 3 : Deploy a Private Billing Service

3.1 Go to the resource directory
```
cd ~/pet-theory/lab07/staging-api-billing
```
3.2 Build & deploy image for the private billing service
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2
gcloud run deploy $PRIVATE_BILLING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2
```


## Task - 4 : Create a Billing Service Account

4.1 Create billing service account
```
gcloud iam service-accounts create $BILLING_SERVICE_ACCOUNT --display-name "Billing Service Account Cloud Run"
```

## Task - 5 : Deploy a Billing Service in Production

5.1 Go to the resource directory
```
cd ~/pet-theory/lab07/prod-api-billing
```

5.2 Build & deploy image for the production billing service
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1
gcloud run deploy $BILLING_PROD_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1
```

## Task - 6 : Create a Frontend Service Account

6.1 Create frontend service account
```
gcloud iam service-accounts create $FRONTEND_SERVICE_ACCOUNT --display-name "Billing Service Account Cloud Run Invoker"
```

## Task - 7 : Deploy the Frontend Service in Production

7.1 Go to the resource directory
```
cd ~/pet-theory/lab07/prod-frontend-billing
```
7.2 Build & deploy image for the frontend production service
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1
gcloud run deploy $FRONTEND_PRODUCTION_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1
```

# Lab Completed

