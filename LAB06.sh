Task 1:-

gcloud auth list
gsutil cat gs://cloud-training/gsp318/marking/setup_marking_v2.sh | bash
gcloud source repos clone valkyrie-app
cd valkyrie-app
cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF
docker build -t valkyrie-dev:v0.0.1 .
cd ..
cd marking
./step1_v2.sh

//valkyrie-dev:v0.0.1


Task 2:-
cd ..
cd valkyrie-app
docker run -p 8080:8080 valkyrie-dev:v0.0.1 &
cd ..
cd marking
./step2_v2.sh
bash ~/marking/step2_v2.sh


Task 3:-

cd ..
cd valkyrie-app

gcloud artifacts repositories create valkyrie-docker-repo \
    --repository-format=docker \
    --location=us-east4 \
    --description="docker repo" \
    --async 

gcloud auth configure-docker us-east4-docker.pkg.dev

docker images
//Image_ID=12927dd9b3fe

//LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE.

//docker rmi 12927dd9b3fe -f 
//docker image prune
//docker container ls 

docker tag 12927dd9b3fe us-east4-docker.pkg.dev/qwiklabs-gcp-01-882b1b5ef637/valkyrie-docker-repo/valkyrie-dev:v0.0.1

docker push us-east4-docker.pkg.dev/qwiklabs-gcp-01-882b1b5ef637/valkyrie-docker-repo/valkyrie-dev:v0.0.1



Task 4:-

sed -i s#IMAGE_HERE#us-east4-docker.pkg.dev/qwiklabs-gcp-01-882b1b5ef637/valkyrie-docker-repo/valkyrie-dev:v0.0.1#g k8s/deployment.yaml

gcloud container clusters get-credentials valkyrie-dev --zone us-east4-c
kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/service.yaml

