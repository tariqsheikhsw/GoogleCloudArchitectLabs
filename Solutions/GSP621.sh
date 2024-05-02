### Query#1

SELECT * FROM `billing_dataset.enterprise_billing` WHERE Cost > 0


### Query#2

SELECT
 project.name as Project_Name,
 service.description as Service,
 location.country as Country,
 cost as Cost
FROM `billing_dataset.enterprise_billing`;

### Query#3

SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1

### Query#4

SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item, Count(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, ' : ',sku.description)

### Query#5

SELECT project.id, count(*) as count from `billing_dataset.enterprise_billing` GROUP BY project.id

### Query#6

SELECT ROUND(SUM(cost),2) as Cost, project.name from `billing_dataset.enterprise_billing` GROUP BY project.name
