### GSPlll :  Implementing Cloud SQL (Azure) 

Working Solution :

```
curl -LO https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSPlll.sh

sudo chmod +x GSPlll.sh

./GSPlll.sh
```


```
export ZONE=us-east1-b
export REGION=us-east1
```

//Previous version of lab
```
#export ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --format="value(zone)" | head -n 1)
#export REGION="${ZONE%-*}"
```

```
curl -LO https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSPlll-old.sh

sudo chmod +x GSPlll-old.sh

./GSPlll-old.sh
```
