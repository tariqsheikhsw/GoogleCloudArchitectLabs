
gcloud auth list
gcloud config list project

git clone https://github.com/rosera/pet-theory
cd pet-theory/lab01
npm install @google-cloud/firestore
npm install @google-cloud/logging

curl -LO https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSP642/importTestData.js

npm install faker@5.5.3

curl -LO https://raw.githubusercontent.com/tariqsheikhsw/GoogleCloudArchitectLabs/main/Solutions/GSP642/createTestData.js

node createTestData 1000
node importTestData customers_1000.csv
npm install csv-parse
