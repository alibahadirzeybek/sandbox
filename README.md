# sandbox

The project uses terraform to build a custom image, deploy required kubernetes
manifests and deploy helm releases on the currently configured kubernetes cluster
at the kubectl. The local kubernetes provider, i.e. minikube, is suggested to be
able to use the custom image since it does not push the image to any remote repository.


## Required Permissions on AWS

If you would like to use a different name for AWS resourcesother than `vvp`,
you can change the `unique_name` under `modules/aws/locals.tf` which will 
change the naming for S3 bucket, IAM user and IAM policy.

Please then change the resource ARN's accordingly in the following statement
or directly apply this for the user of terminal that is running the terraform.
Do not forget to change the `<ACCOUNT_ID>` of the AWS account that will be used.

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::vvp"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "iam:*",
			"Resource": [
				"arn:aws:iam::<ACCOUNT_ID>:user/vvp",
				"arn:aws:iam::<ACCOUNT_ID>:policy/vvp"
			]
		}
	]
}
```


## Using Terraform

Creating the resources

`terraform apply`

Outputting the '<ACCESS_KEY>' and '<SECRET_KEY>'

`terraform output -json`

Destroy the resources

`terraform destroy` 


## Port Forwarding

VVP

`kubectl port-forward --namespace=vvp services/vvp-ververica-platform 8080:80`

Kibana

`kubectl port-forward --namespace=kibana services/kibana 5601:5601`


## SQL Scripts

```
CREATE TABLE login_events (
    user_name STRING NOT NULL,
    login_time TIMESTAMP(3)
)
WITH (
    'connector'     = 'jdbc',
    'url'           = 'jdbc:mysql://mysql.mysql.svc:3306/events',
    'username'      = 'root',
    'password'      = 'password',
    'table-name'    = 'login'
);
```


```
INSERT INTO login_events (user_name)
VALUES ('john_doe');
```


```
SELECT *
FROM login_events;
```


```
CREATE TABLE login_events_binlog (
    user_name STRING NOT NULL,
    login_time TIMESTAMP(3) NOT NULL,
    PRIMARY KEY(user_name, login_time) NOT ENFORCED
) WITH (
    'connector'     = 'mysql-cdc',
    'hostname'      = 'mysql.mysql.svc',
    'port'          = '3306',
    'username'      = 'root',
    'password'      = 'password',
    'database-name' = 'events',
    'table-name'    = 'login'
);
```


```
CREATE CATALOG streamhouse WITH (
    'type'          = 'paimon',
    'warehouse'     = 's3://vvp/warehouse',
    's3.access-key' = '<ACCESS_KEY>',
    's3.secret-key' = '<SECRET_KEY>'
);
```


```
USE CATALOG streamhouse;
CREATE DATABASE events;
```


```
USE CATALOG streamhouse;
USE events;
CREATE TABLE login (
    user_name STRING NOT NULL,
    login_time TIMESTAMP(3) NOT NULL,
    PRIMARY KEY (user_name, login_time) NOT ENFORCED
);
```


```
INSERT INTO streamhouse.events.login
SELECT * FROM login_events_binlog;
```


```
CREATE VIEW login_events_year_month AS (
    SELECT
        user_name,
        CONCAT(
            CAST(YEAR(login_time) AS STRING),
            '_',
            CAST(MONTH(login_time) AS STRING)
        ) AS yyyy_mm
    FROM streamhouse.events.login
);
```


```
CREATE TABLE login_events_count_per_month (
   user_name STRING,
   yyyy_mm STRING,
   login_count BIGINT,
   PRIMARY KEY (user_name, yyyy_mm) NOT ENFORCED
) WITH (
    'connector'     = 'elasticsearch-7',
    'hosts'         = 'http://elasticsearch.elasticsearch.svc:9200',
    'index'         = 'login_events_count_per_month'
);
```


```
INSERT INTO login_events_count_per_month
SELECT
    user_name,
    yyyy_mm,
    COUNT(*) AS login_count
FROM login_events_year_month
GROUP BY user_name, yyyy_mm;
```


```
CREATE TABLE login_events_top_user_per_month (
   user_name STRING,
   yyyy_mm STRING,
   PRIMARY KEY (yyyy_mm) NOT ENFORCED
) WITH (
    'connector'     = 'elasticsearch-7',
    'hosts'         = 'http://elasticsearch.elasticsearch.svc:9200',
    'index'         = 'login_events_top_user_per_month'
);
```


```
INSERT INTO login_events_top_user_per_month
SELECT user_name, yyyy_mm
FROM (
    SELECT
        user_name,
        yyyy_mm,
        ROW_NUMBER() OVER (PARTITION BY yyyy_mm ORDER BY login_count DESC) AS row_num
    FROM (
        SELECT
            user_name,
            yyyy_mm,
            COUNT(*) AS login_count
        FROM login_events_year_month
        GROUP BY user_name, yyyy_mm
    )
)
WHERE row_num = 1;
```