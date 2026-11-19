output "workspace_host" {
  value = module.databricks_mws_workspace.workspace_url
}

output "catalog_name" {
  description = "Name of the catalog created for the workspace. Null when create_workspace_catalog is false."
  value       = one(module.unity_catalog_catalog_creation[*].catalog_name)
}
