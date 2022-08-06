 terraform {
  required_version = ">= 0.1.0.7"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }

    vault = {
      version = "3.0.1"
    }
  }
}

provider "vault" {
  address = "http://localhost:8201"
  token   = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}

provider "vault" {
  alias   = "vault_dev"
  address = "http://localhost:8201"
  token   = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}

provider "vault" {
  alias   = "vault_staging"
  address = "http://localhost:8401"
  token   = "f23612cf-824d-4206-9e94-e31a6dc8ee8d"
}

provider "vault" {
  alias   = "vault_prod"
  address = "http://localhost:8301"
  token   = "083672fc-4471-4ec4-9b59-a285e463a973"
}
                                              #---------------------------

variable "provider" {
   type = map(string)
   default = {
      dev = "vault.vault_dev"
      staging = "vault.vault_staging"
      production = "vault.vault_prod"  

   }
}

#accual values inside here
dev.tfvars
staging.tfvars
prod.tfvars

# modify provider by using lookup function and adding staging 

resource "vault_audit" "audit_dev" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_audit" "audit_staging" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

resource "vault_audit" "audit_prod" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}

# modify provider added staging

resource "vault_auth_backend" "userpass_dev" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "userpass"
}

resource "vault_auth_backend" "userpass_staging" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "userpass"
}

resource "vault_auth_backend" "userpass_prod" {
  provider = lookup(var.provider, terraform.workspace)
  type     = "userpass"
}

# modify account using  var.provider

resource "vault_generic_secret" "account_development" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/development/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
}

resource "vault_policy" "account_development" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "account-development"

  policy = <<EOT
path "secret/data/development/account" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "account_development" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/account-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-development"],
  "password": "123-account-development"
}
EOT
}

#gateway

resource "vault_generic_secret" "gateway_development" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/development/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
}

resource "vault_policy" "gateway_development" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "gateway-development"

  policy = <<EOT
path "secret/data/development/gateway" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "gateway_development" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/gateway-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-development"],
  "password": "123-gateway-development"
}
EOT
}
resource "vault_generic_secret" "payment_development" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/development/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
}

resource "vault_policy" "payment_development" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "payment-development"

  policy = <<EOT
path "secret/data/development/payment" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "payment_development" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_dev]
  path                 = "auth/userpass/users/payment-development"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-development"],
  "password": "123-payment-development"
}
EOT
}

resource "vault_generic_secret" "account_production" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/production/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
}
EOT
}

resource "vault_policy" "account_production" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "account-production"

  policy = <<EOT
path "secret/data/production/account" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "account_production" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/account-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["account-production"],
  "password": "123-account-production"
}
EOT
}

resource "vault_generic_secret" "gateway_production" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/production/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "33fc0cc8-b0e3-4c06-8cf6-c7dce2705329"
}
EOT
}

resource "vault_policy" "gateway_production" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "gateway-production"

  policy = <<EOT
path "secret/data/production/gateway" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "gateway_production" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/gateway-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["gateway-production"],
  "password": "123-gateway-production"
}
EOT
}

resource "vault_generic_secret" "payment_production" {
  provider = lookup(var.provider, terraform.workspace)
  path     = "secret/production/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e39"
}
EOT
}

resource "vault_policy" "payment_production" {
  provider = lookup(var.provider, terraform.workspace)
  name     = "payment-production"

  policy = <<EOT
path "secret/data/production/payment" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "payment_production" {
  provider             = lookup(var.provider, terraform.workspace)
  depends_on           = [vault_auth_backend.userpass_prod]
  path                 = "auth/userpass/users/payment-production"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["payment-production"],
  "password": "123-payment-production"
}
EOT
}

resource "docker_container" "account_production" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=account-production",
    "VAULT_PASSWORD=123-account-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_production" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=gateway-production",
    "VAULT_PASSWORD=123-gateway-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_production" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_production"

  env = [
    "VAULT_ADDR=http://vault-production:8200",
    "VAULT_USERNAME=payment-production",
    "VAULT_PASSWORD=123-payment-production",
    "ENVIRONMENT=production"
  ]

  networks_advanced {
    name = "vagrant_production"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "account_development" {
  image = "form3tech-oss/platformtest-account"
  name  = "account_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=account-development",
    "VAULT_PASSWORD=123-account-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "gateway_development" {
  image = "form3tech-oss/platformtest-gateway"
  name  = "gateway_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=gateway-development",
    "VAULT_PASSWORD=123-gateway-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "payment_development" {
  image = "form3tech-oss/platformtest-payment"
  name  = "payment_development"

  env = [
    "VAULT_ADDR=http://vault-development:8200",
    "VAULT_USERNAME=payment-development",
    "VAULT_PASSWORD=123-payment-development",
    "ENVIRONMENT=development"
  ]

  networks_advanced {
    name = "vagrant_development"
  }

  lifecycle {
    ignore_changes = all
  }
}
