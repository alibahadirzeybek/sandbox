output "cluster_ip" {
  value = aws_emr_cluster.vvp.master_public_dns
}
