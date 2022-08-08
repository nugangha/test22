# user auth
resource "vault_auth_backend" "userpass_dev" {
  provider = vault.vault_dev
  type     = "userpass"
}

resource "vault_auth_backend" "userpass_staging" {
  provider = vault.vault_staging
  type     = "userpass"
}

resource "vault_auth_backend" "userpass_prod" {
  provider = vault.vault_prod
  type     = "userpass"
}
