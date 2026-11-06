# Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster

# Cluster Version
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

# Cluster Creation
resource "databricks_cluster" "example" {
  cluster_name            = "Standard Classic Compute Plane Cluster"
  data_security_mode      = "USER_ISOLATION"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = var.enable_compliance_security_profile ? "m6idn.xlarge" : (var.region == "us-gov-west-1" ? "i3en.xlarge" : "i3.xlarge")
  autotermination_minutes = 10
  is_single_node          = true
  kind                    = "CLASSIC_PREVIEW"

  # Custom Tags
  # Databricks adds ResourceClass = SingleNode itself because is_single_node is true.
  # Set it here as well, or every plan tries to remove it.
  custom_tags = merge(
    {
      "SRA" = var.resource_prefix
    },
    var.custom_tags,
    {
      "ResourceClass" = "SingleNode"
    }
  )
}