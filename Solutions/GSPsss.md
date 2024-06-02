### GSPsss :  Caching Content with Cloud CDN 

//Bucket and Load Balancer 
```
PROJECT-ID=qwiklabs-gcp-04-6654b4c8fbf9

gsutil cp gs://cloud-training/gcpnet/cdn/cdn.png gs://qwiklabs-gcp-04-6654b4c8fbf9

gsutil acl ch -u AllUsers:R gs://qwiklabs-gcp-04-6654b4c8fbf9/cdn.png
```
