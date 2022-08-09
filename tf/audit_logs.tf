resource "vault_audit" "audit_dev" {
  provider = vault.vault_dev
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}
/*
resource "vault_audit" "audit_staging" {
  provider = vault.vault_staging
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}
*/
resource "vault_audit" "audit_prod" {
  provider = vault.vault_prod
  type     = "file"

  options = {
    file_path = "/vault/logs/audit"
  }
}
