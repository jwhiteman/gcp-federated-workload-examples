output "aws_instance_public_ip" {
  description = "Public IP address of the AWS instance"
  value       = aws_instance.some_aws_instance.public_ip
}

output "aws_instance_public_dns" {
  description = "Public DNS name of the AWS EC2 instance"
  value       = aws_instance.some_aws_instance.public_dns
}

output "aws_assumed_role_arn" {
  description = "AWS assumed role arn"
  value       = "arn:aws:sts::${local.aws_account_id}:assumed-role/${aws_iam_role.some_aws_role.name}/${aws_instance.some_aws_instance.id}"
}

output "workload_identity_pool_provider" {
  value = "projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/${local.gcp_pool_id}/providers/${local.gcp_provider_id}"
}

resource "null_resource" "create_cred_config" {
  provisioner "local-exec" {
    command = <<EOT
      gcloud iam workload-identity-pools create-cred-config \
        projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/${local.gcp_pool_id}/providers/${local.gcp_provider_id} \
        --aws \
        --enable-imdsv2 \
        --output-file=tmp/federated-config.json
    EOT
  }

  depends_on = [google_iam_workload_identity_pool.some_pool, google_iam_workload_identity_pool_provider.some_provider]
}
