### GSP364 :  Monitor Environments with Google Cloud Managed Service for Prometheus: Challenge Lab 

------------------------------------------------------------------------------------------------------------------------------------------------------------------

TASK 1:-


gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone us-central1-f --enable-managed-prometheus

gcloud container clusters get-credentials gmp-cluster --zone=us-central1-f

kubectl create ns gmp-system


------------------------------------------------------------------------------------------------------------------------------------------------------------------

TASK 2:-


kubectl -n gmp-system apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/main/examples/self-pod-monitoring.yaml



------------------------------------------------------------------------------------------------------------------------------------------------------------------


TASK 3:-


kubectl -n gmp-system apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/main/examples/example-app.yaml



------------------------------------------------------------------------------------------------------------------------------------------------------------------

                           Congratulations, you're all done with the lab 😄 Don't forget to subscribe our YouTube Channel😄
                                        
                                                                 Thanks for watching.!
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
