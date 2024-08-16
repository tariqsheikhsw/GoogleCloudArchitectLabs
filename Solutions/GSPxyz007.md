### GSPxyz007 :  Integrating Cloud Functions with Firestore 

* Go to `Create database` from [here](https://console.cloud.google.com/firestore/create-database?)

### Create a New Document Collection

* For Collection ID Paste the Following

```
customers
```

* To generate an ID for a document in this collection, click into `Document ID`.

* Now Paste the following

|   Field   |  Type  |  Value  |
|   :---:   | :----: | :----:  |
| firstname | string | Lucas   |
| lastname  | string | Sherman |

### Run the following Commands in CloudShell

```
export REGION=us-east4
```

```
curl -LO raw.githubusercontent.com/QUICK-GCP-LAB/2-Minutes-Labs-Solutions/main/Integrating%20Cloud%20Functions%20with%20Firestore/shell.sh

sudo chmod +x shell.sh

./shell.sh
```

* Delete and Re-Create Last Field

|   Field   |  Type  |  Value  |
|   :---:   | :----: | :----:  |
| lastname  | string | Sherman |

### Lab Completed !!! 
