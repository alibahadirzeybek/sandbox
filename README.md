# sandbox

The project uses terraform to build a custom image, deploy required kubernetes
manifests and deploy helm releases on the currently configured kubernetes cluster
at the kubectl. The local kubernetes provider, i.e. minikube, is suggested to be
able to use the custom image since it does not push the image to any remote repository.


## Required Permissions on AWS

If you would like to use a different name for AWS resourcesother than `vvp`,
you can change the `unique_name` under `modules/aws/locals.tf` which will
change the naming for S3 bucket, IAM user, IAM policy, etc.

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
			"Action": [
				"ec2:DescribeInternetGateways",
				"ec2:DescribeSecurityGroupRules",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribeVpcs",
				"elasticmapreduce:*",
				"ec2:DescribeSubnets",
				"ec2:DescribeKeyPairs",
				"ec2:DescribeRouteTables",
				"ec2:DescribeSecurityGroups"
			],
			"Resource": "*"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "iam:PassRole",
			"Resource": [
				"arn:aws:iam::<ACCOUNT_ID>:role/EMR_DefaultRole",
				"arn:aws:iam::<ACCOUNT_ID>:role/EMR_EC2_DefaultRole"
			]
		},
		{
			"Sid": "VisualEditor2",
			"Effect": "Allow",
			"Action": "ec2:*",
			"Resource": [
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:security-group/*",
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:internet-gateway/*",
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:vpc/*",
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:route-table/*",
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:key-pair/vvp-hive-catalog",
				"arn:aws:ec2:us-west-1:<ACCOUNT_ID>:subnet/*"
			]
		},
		{
			"Sid": "VisualEditor3",
			"Effect": "Allow",
			"Action": "s3:*",
			"Resource": [
				"arn:aws:s3:::vvp-hive-catalog/*",
				"arn:aws:s3:::vvp-hive-catalog"
			]
		},
		{
			"Sid": "VisualEditor4",
			"Effect": "Allow",
			"Action": "iam:*",
			"Resource": [
				"arn:aws:iam::<ACCOUNT_ID>:policy/vvp-hive-catalog",
				"arn:aws:iam::<ACCOUNT_ID>:user/vvp-hive-catalog"
			]
		}
	]
}
```


## Using Terraform

Creating the resources

`terraform apply`

Outputting the '<CLUSTER_IP>' and '<BUCKET_NAME>'

`terraform output -json`

Destroy the resources

`terraform destroy`



## Port Forwarding

VVP

`kubectl port-forward --namespace=vvp services/vvp-ververica-platform 8080:80`


## Hive Setup

```
chmod 400 vvp-hive-catalog.pem
```

```
ssh -i ./vvp-hive-catalog.pem hadoop@<CLUSTER_IP>
```

```
hive
```


```
CREATE EXTERNAL TABLE event (name STRING) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
WITH SERDEPROPERTIES ('avro.schema.url'='s3a://vvp-hive-catalog/schema/schema.avsc')
STORED AS AVRO LOCATION 's3a://vvp-hive-catalog/data/';
```


## Catalog Setup
```
CREATE CATALOG hive
WITH (
  'type' = 'hive',
  'hive-version' = '3.1.3',
  'hive-conf-dir' = '/etc/hive'
);
```
