resource "vault_generic_secret" "payment_development" {
  provider = vault.vault_dev
  path     = "secret/development/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "a63e8938-6d49-49ea-905d-e03a683059e7"
}
EOT
}

resource "vault_policy" "payment_development" {
  provider = vault.vault_dev
  name     = "payment-development"

  policy = <<EOT
path "secret/data/development/payment" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "payment_development" {
  provider             = vault.vault_dev
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

#-------------------------
resource "vault_generic_secret" "payment_production" {
  provider = vault.vault_prod
  path     = "secret/production/payment"

  data_json = <<EOT
{
  "db_user":   "payment",
  "db_password": "821462d7-47fb-402c-a22a-a58867602e39"
}
EOT
}

resource "vault_policy" "payment_production" {
  provider = vault.vault_prod
  name     = "payment-production"

  policy = <<EOT
path "secret/data/production/payment" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "payment_production" {
  provider             = vault.vault_prod
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

#---------------
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


