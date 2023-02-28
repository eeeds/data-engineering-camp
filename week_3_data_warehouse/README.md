## Data Warehouse and BigQuery

- [Slides](https://docs.google.com/presentation/d/1a3ZoBAXFk8-EhUsd7rAZd-5p_HpltkzSeujjRGB2TAI/edit?usp=sharing)  
- [Big Query basic SQL](big_query.sql)


### Data Warehouse

- [Data Warehouse and BigQuery](https://youtu.be/jrHljAoD6nM)

### Partitoning and clustering

- [Partioning and Clustering](https://youtu.be/jrHljAoD6nM?t=726)  
- [Partioning vs Clustering](https://youtu.be/-CqXf7vhhDs)  

### Best practices

- [BigQuery Best Practices](https://youtu.be/k81mLJVX08w)  
### Cost Reduction
> Avoid Select *
> Prices your queries before you running them
> Use clustered or partitioned tables
> Use streaming inserts with caution
> Materialize query results in stages
### Query performance
> Filter on partitioned columns
> Denormalizing data
> Use nested or repeated columns
> Use external data sources appropriately
> Don't use it, in case you want a high query performance
> Reduce data before using a JOIN
> Do no treat WITH clauses as prepared statements
> Avoid oversharding tables

### Internals of BigQuery

- [Internals of Big Query](https://youtu.be/eduHi1inM4s)  
> Column Oriented Storage
> Big Query divides the data into smallest chunks and it processes in that way. 

### Advanced

#### ML
[BigQuery Machine Learning](https://youtu.be/B-WtpB0PuG4)  
[SQL for ML in BigQuery](big_query_ml.sql)

**Important links**
- [BigQuery ML Tutorials](https://cloud.google.com/bigquery-ml/docs/tutorials)
- [BigQuery ML Reference Parameter](https://cloud.google.com/bigquery-ml/docs/analytics-reference-patterns)
- [Hyper Parameter tuning](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-create-glm)
- [Feature preprocessing](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-preprocess-overview)

##### Deploying ML model

- [BigQuery Machine Learning Deployment](https://youtu.be/BjARzEWaznU)  
- [Steps to extract and deploy model with docker](extract_model.md)  



### Homework

* [Homework](../homeworks/week_3)


## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/3_data_warehouse.md)
* [Isaac Kargar's blog post](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/30/data-engineering-w3.html)
* [Marcos Torregrosa's blog post](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-3/) 
* Add your notes here (above this line)