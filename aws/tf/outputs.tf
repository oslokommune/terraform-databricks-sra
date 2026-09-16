output "workspace_host" {
  value = module.databricks_mws_workspace.workspace_url
}

output "catalog_name" {
  description = "Name of the catalog created for the workspace. Null for serverless-only workspaces, which use the auto-created workspace catalog, and when create_workspace_catalog is false."
  value       = local.is_serverless || !var.create_workspace_catalog ? null : module.unity_catalog_catalog_creation[0].catalog_name
}
