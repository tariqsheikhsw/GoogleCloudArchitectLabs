### GSP747 :  Deploy a Hugo Website with Cloud Build and Firebase Pipeline 

## Run in cloudshell
```cmd
gcloud compute ssh --zone "us-central1-f" "hugo-dev-vm" --quiet
```
```cmd
cd ~
/tmp/installhugo.sh
sudo apt-get update
yes | sudo apt-get install git
cd ~
gcloud source repos create my_hugo_site
gcloud source repos clone my_hugo_site
cd ~
/tmp/hugo new site my_hugo_site --force
cd ~/my_hugo_site
git clone \
  https://github.com/budparr/gohugo-theme-ananke.git \
  themes/ananke
echo 'theme = "ananke"' >> config.toml
sudo rm -r themes/ananke/.git
sudo rm themes/ananke/.gitignore
cd ~/my_hugo_site
/tmp/hugo server -D --bind 0.0.0.0 --port 8080
```
### Click on the link in terminal (`htttp://localhost:8080/`)
### IMPORTANT! Check your 1 and 2 progress 
### Now go back to cloud shell and press `ctrl+c`
### open link in incognito [Firebase](https://console.firebase.google.com/) > Add project > select GCP ID > confirm all the terms and cond > continue > confirm plan > continue > continue > check box > add firebase (Don't worry if you get `The operation has failed`)
### Now go back to cloud shell 
```cmd
curl -sL https://firebase.tools | bash
cd ~/my_hugo_site
firebase init
/tmp/hugo && firebase deploy
```
### By down arrow key go to `Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys`
### Press spacebar and then enter 
### Enter > Enter > Press N > Press N > Press N
```cmd
git config --global user.name "hugo"
git config --global user.email "hugo@blogger.com"
cd ~/my_hugo_site
echo "resources" >> .gitignore
git add .
git commit -m "Add app to Cloud Source Repositories"
git push -u origin master
cd ~/my_hugo_site
cp /tmp/cloudbuild.yaml .
gcloud alpha builds triggers import --source=/tmp/trigger.yaml
cd ~/my_hugo_site
sed -i "s/'My New Hugo Site'/'Blogging with Hugo and Cloud Build'/" config.toml
git add .
git commit -m "I updated the site title"
git push -u origin master
```
```cmd
gcloud builds log $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD))
```
```cmd
gcloud builds log $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD)) | grep "Hosting URL"
```
### Run the last command untill you see required output/hosting URL

