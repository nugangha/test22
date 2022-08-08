resource "vault_generic_secret" "account_development" {
  provider = vault.vault_dev
  path     = "secret/development/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "965d3c27-9e20-4d41-91c9-61e6631870e7"
}
EOT
}

resource "vault_policy" "account_development" {
  provider = vault.vault_dev
  name     = "account-development"

  policy = <<EOT
path "secret/data/development/account" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "account_development" {
  provider             = vault.vault_dev
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

#-----------

resource "vault_generic_secret" "account_production" {
  provider = vault.vault_prod
  path     = "secret/production/account"

  data_json = <<EOT
{
  "db_user":   "account",
  "db_password": "396e73e7-34d5-4b0a-ae1b-b128aa7f9977"
}
EOT
}

resource "vault_policy" "account_production" {
  provider = vault.vault_prod
  name     = "account-production"

  policy = <<EOT
path "secret/data/production/account" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "account_production" {
  provider             = vault.vault_prod
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
