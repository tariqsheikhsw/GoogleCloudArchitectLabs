gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Portfolio (PortfolioId, Name, ShortName, PortfolioInfo) VALUES (1, 'Banking', 'Bnkg', 'All Banking Business')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Portfolio (PortfolioId, Name, ShortName, PortfolioInfo) VALUES (2, 'Asset Growth', 'AsstGrwth', 'All Asset Focused Products')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Portfolio (PortfolioId, Name, ShortName, PortfolioInfo) VALUES (3, 'Insurance', 'Ins', 'All Insurance Focused Products')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Category (CategoryId, PortfolioId, CategoryName) VALUES (1, 1, 'Cash')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Category (CategoryId, PortfolioId, CategoryName) VALUES (2, 2, 'Investments - Short Return')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Category (CategoryId, PortfolioId, CategoryName) VALUES (3, 2, 'Annuities')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Category (CategoryId, PortfolioId, CategoryName) VALUES (4, 3, 'Life Insurance')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (1, 1, 1, 'Checking Account', 'ChkAcct', 'Banking LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (2, 2, 2, 'Mutual Fund Consumer Goods', 'MFundCG', 'Investment LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (3, 3, 2, 'Annuity Early Retirement', 'AnnuFixed', 'Investment LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (4, 4, 3, 'Term Life Insurance', 'TermLife', 'Insurance LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (5, 1, 1, 'Savings Account', 'SavAcct', 'Banking LOB')"


gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (6, 1, 1, 'Personal Loan', 'PersLn', 'Banking LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (7, 1, 1, 'Auto Loan', 'AutLn', 'Banking LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (8, 4, 3, 'Permanent Life Insurance', 'PermLife', 'Insurance LOB')"

gcloud spanner databases execute-sql banking-ops-db --instance=banking-ops-instance --sql="INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass) VALUES (9, 2, 2, 'US Savings Bonds', 'USSavBond', 'Investment LOB')"


mkdir python-helper
cd python-helper

wget https://storage.googleapis.com/cloud-training/OCBL373/requirements.txt
wget https://storage.googleapis.com/cloud-training/OCBL373/snippets.py

virtualenv env
source env/bin/activate
pip install -r requirements.txt

python snippets.py banking-ops-instance --database-id  banking-ops-db insert_data


python snippets.py banking-ops-instance --database-id  banking-ops-db query_data


python snippets.py banking-ops-instance --database-id  banking-ops-db add_column

python snippets.py banking-ops-instance --database-id  banking-ops-db update_data

python snippets.py banking-ops-instance --database-id  banking-ops-db query_data_with_new_column

python snippets.py banking-ops-instance --database-id  banking-ops-db add_index







