### GSP217 :  Cloud CDN 

(MANUAL STEPS)

```
export PROJECT_ID=qwiklabs-gcp-04-73f82f18f5a6
```

Task 1. Create and populate a Cloud Storage bucket
Create Bucket : PROJECT_ID
```
gsutil cp gs://cloud-training/gcpnet/cdn/cdn.png gs://$PROJECT_ID

```
Task 2. Create the HTTP Load Balancer with Cloud CDN (MANUAL)


Task 3. Verify the caching of your bucket's content

Replace LB_IP_ADDRESS value
```
export LB_IP_ADDRESS=X.X.X.X

for i in {1..3};do curl -s -w "%{time_total}\n" -o /dev/null http://$LB_IP_ADDRESS/cdn.png; done

for i in {1..3};do curl -s -w "%{time_total}\n" -o /dev/null http://$LB_IP_ADDRESS/cdn.png; done
```
