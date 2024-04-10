resource "prosimo_network_onboarding" "example_network" {

    name = var.network_name
    namespace = var.network_namespace
    network_exportable_policy = true
    public_cloud {
        cloud_type = var.cloud_type
        connection_option = var.connectType
        cloud_creds_name = var.cloudNickname
        region_name = var.region
        cloud_networks {
          vpc = var.vpc
          hub_id = var.tgw_id
          connector_placement = var.placement
          connectivity_type = var.connectivity_type
          dynamic "subnets" {
            for_each = var.subnets_config

            content {
              subnet         = subnets.value.subnet
              virtual_subnet = lookup(subnets.value, "virtual_subnet", null)  # Use lookup to handle optional field
            }
          }
          connector_settings {
            bandwidth_range {
            min = 1
            max = 1
        }
          }
        }
       connect_type = "connector"
    }
    policies = ["ALLOW-ALL-NETWORKS"]
    onboard_app = var.onboard
    decommission_app = var.decommission
    wait_for_rollout = false
}
