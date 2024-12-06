Set the following vars in Gitlab under Settings > CI/CD > Variables

```
WORKLOAD_IDENTITY_PROJECT_NUMBER
WORKLOAD_IDENTITY_POOL
WORKLOAD_IDENTITY_PROVIDER
SERVICE_ACCOUNT (the fully qualified service account name - no member prefix needed)

TF_VAR_gcp_project
```

Run `terraform apply` under pool/ which will create the pool & backend bucket.

From there .gitlab-ci.yml should work, using the terraform files under build/
