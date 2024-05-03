

gcloud compute instances list \
    --filter='tags.items=(vmseries-tutorial)' \
    --format='value(EXTERNAL_IP)'

