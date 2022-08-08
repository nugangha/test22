resource "vault_generic_secret" "gateway_development" {
  provider = vault.vault_dev
  path     = "secret/development/gateway"

  data_json = <<EOT
{
  "db_user":   "gateway",
  "db_password": "10350819-4802-47ac-9476-6fa781e35cfd"
}
EOT
}

resource "vault_policy" "gateway_development" {
  provider = vault.vault_dev
  name     = "gateway-development"

  policy = <<EOT
path "secret/data/development/gateway" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "gateway_development" {
  provider             = vault.vault_dev
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
