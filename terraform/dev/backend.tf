bucket         = "joindevops-shop1"
key            = "catalogue-dev"
region         = "us-east-1"
dynamodb_table = "joindevops-shop-lock1"



#How to execute the cmd for both prod and dev
#terraform init --backend-config=PROD/backend.tf (for first time)
# terraform init -reconfigure -backend-config=PROD/backend.tf
# terraform plan -var-file=PROD/prod.tfvars
# terraform apply -var-file=DEV/dev.tfvars


