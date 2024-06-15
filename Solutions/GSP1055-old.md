### GSP1055 : Streaming Data to Bigtable 

//Ensure zone is updated in below command
```
gcloud bigtable instances create sandiego \
--display-name="San Diego Traffic Sensors" \
--cluster-storage-type=SSD \
--cluster-config=id=sandiego-traffic-sensors-c1,zone=us-west3-c,nodes=1

echo project = `gcloud config get-value project` \
    >> ~/.cbtrc

echo instance = sandiego \
    >> ~/.cbtrc

cat ~/.cbtrc

cbt createtable current_conditions \
    families="lane"
```

### SSH (training-vm)

```
ls /training

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

source /training/project_env.sh

/training/sensor_magic.sh
```

### NEW SSH TERMINAL/CONNECTION 

```
source /training/project_env.sh

cd ~/training-data-analyst/courses/streaming/process/sandiego

//nano run_oncloud.sh

./run_oncloud.sh $DEVSHELL_PROJECT_ID $BUCKET CurrentConditions --bigtable

```

### Dataflow > Jobs (STOP)

```
cbt read current_conditions count=5 \
    columns="lane:.*"


//first SSH terminal, Ctrl-C

cbt deletetable current_conditions

gcloud bigtable instances delete sandiego

```


