resource "aws_emr_cluster" "vvp" {
  name                                  = var.name
  release_label                         = "emr-7.0.0"
  applications                          = ["hive"]

  ec2_attributes {
    key_name                            = var.key_name
    subnet_id                           = var.subnet_id
    emr_managed_master_security_group   = var.security_group_id
    emr_managed_slave_security_group    = var.security_group_id
    instance_profile                    = "EMR_EC2_DefaultRole"
  }

  master_instance_group {
    instance_type                       = "m4.large"
  }

  core_instance_group {
    instance_type                       = "c4.large"
    instance_count                      = 1
  }

  service_role                          = "EMR_DefaultRole"

  connection {
    type                                = "ssh"
    user                                = "hadoop"
    host                                = self.master_public_dns
    private_key                         = var.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "hive -e \"CREATE EXTERNAL TABLE events (user_name STRING) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' WITH SERDEPROPERTIES ('avro.schema.url' = 's3a://${var.bucket_name}/schema/schema.avsc') STORED AS AVRO;\""
    ]
  }
}
