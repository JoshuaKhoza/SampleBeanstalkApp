# Terraform Remote Backend

Bootstrap terraform remote states.

Rolls out an S3 bucket and DynamoDB table as the core resources for the terraform remote backend.

*Disclaimer: If you have an existing remote strategy initialization you can entirely ignore this module.*

### 1. Set stage and command in `deploy.py`
```
stage = 'dev'  # 'dev|int|prod'
domain = 'qs-blueprint' # update to your domain
command = 'apply'  # 'apply|destroy'
```

### 2. Execute deploy script
```
python deploy.py
```

### 3. outputs examples 
```
db_backend = "terraform-state-267084114047-elb-app-infra"
s3_backend = "terraform-state-267084114047-elb-app-infra"
```
