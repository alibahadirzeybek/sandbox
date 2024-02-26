CREATE EXTERNAL TABLE events.login (user_name STRING, login_time BIGINT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
WITH SERDEPROPERTIES ('avro.schema.url' = 's3a://${bucket_name}/schemas/login_event.avsc')
STORED AS AVRO;
