aws_region = [
          "eu-west-2",
          "us-east-1",
]

vpc_cidr = [ 
          "10.0.0.0/16",
          "10.1.0.0/16", 
]

subnet_cidr = [ 
          "10.0.0.0/24",
          "10.1.0.0/24",
 ]

prosimo_cidr = [
          "10.251.0.0/23",
          "10.252.0.0/23",
]

private_ip = [
          "10.0.0.100",
          "10.1.0.100",
]

cloud_type = "AWS"


US_East_FrontEnd = {
  VPC1 = {
    aws_vpc_name          = "WebSvcsProdUs"
    igw_name              = "WebSvcsProdUs-IGW"
    rt_name               = "WebSvcsProdUs-RT"
    aws_subnet_name       = "WebSvcsProdUs-subnet"
    private_ip            = "10.2.0.100"
    aws_ec2_name          = "WebServerProdUs1"
    aws_ec2_key_pair_name = "US_EAST_WebSvcsProd"
    aws_vpc_cidr          = "10.2.0.0/16"
    aws_subnet_cidr       = "10.2.0.0/24"
  },

  VPC2 = {
    aws_vpc_name          = "WebSvcsDevUs"
    igw_name              = "WebSvcsDevUs-IGW"
    rt_name               = "WebSvcsDevUs-RT"
    aws_subnet_name       = "WebSvcsDevUs-subnet"
    private_ip            = "10.3.0.100"
    aws_ec2_name          = "WebServerDevUs1"
    aws_ec2_key_pair_name = "US_EAST_WebSvcsDev"
    aws_vpc_cidr          = "10.3.0.0/16"
    aws_subnet_cidr       = "10.3.0.0/24"
  }
}

EU_West_FrontEnd = {
  VPC1 = {
    aws_vpc_name          = "WebProd1Eu"
    igw_name              = "WebProd1Eu-IGW"
    rt_name               = "WebProd1Eu-RT"
    namespace             = "default"
    aws_subnet_name       = "WebProd1Eu-Subnet"
    private_ip            = "10.2.11.100"
    aws_ec2_name          = "WebServerProdEu1"
    aws_ec2_key_pair_name = "EU_WEST_WebProd1"
    aws_vpc_cidr          = "10.2.0.0/16"
    aws_subnet_cidr       = "10.2.11.0/24"
  },

  VPC2 = {
    aws_vpc_name          = "WebProd2Eu"
    igw_name              = "WebProd2Eu-IGW"
    rt_name               = "WebProd2Eu-RT"
    namespace             = "default"
    aws_subnet_name       = "WebProd2Eu-Subnet"
    private_ip            = "10.3.12.100"
    aws_ec2_name          = "WebServerProdEu2"
    aws_ec2_key_pair_name = "EU_WEST_WebProd2"
    aws_vpc_cidr          = "10.3.0.0/16"
    aws_subnet_cidr       = "10.3.12.0/24"
  },

  VPC3 = {
    aws_vpc_name          = "WebProd3Eu"
    igw_name              = "WebProd3Eu-IGW"
    rt_name               = "WebProd3Eu-RT"
    namespace             = "Vodafone_Dev"
    aws_subnet_name       = "WebProd3Eu-Subnet"
    private_ip            = "10.11.11.100"
    aws_ec2_name          = "WebServerProdEu3"
    aws_ec2_key_pair_name = "EU_WEST_WebProd3"
    aws_vpc_cidr          = "10.11.0.0/16"
    aws_subnet_cidr       = "10.11.11.0/24"
  }
}

North_EU_AppSvcs_VNets = {
  Vnet1 = {
    azure_resource_group        = "AppProdEu1"
    azure_location              = "North Europe"
    azure_vnet_name             = "AppProdEu1_Vnet"
    azure_subnet_name           = "AppProdEu1_Vnet_subnet"
    azure_instance_name         = "AppProdEu1"
    azure_vm_size               = "Standard_DS1_v2"
    azure_server_key_pair_name  = "Azure_Srv1"
    azure_admin_username        = "vodafonelinux"
    azure_admin_password        = "vodafonelinux"
    azure_subnet_cidr           = "10.11.11.0/24"
    azure_vnet_cidr             = "10.11.0.0/16"
    azure_private_ip            = "10.11.11.100"
  },

  Vnet2 = {
    azure_resource_group        = "AppProdEu2"
    azure_location              = "North Europe"
    azure_vnet_name             = "AppProdEu2_Vnet"
    azure_subnet_name           = "AppProdEu2_Vnet_subnet"
    azure_instance_name         = "AppProdEu2"
    azure_vm_size               = "Standard_DS1_v2"
    azure_server_key_pair_name  = "Azure_Srv2"
    azure_admin_username        = "vodafonelinux"
    azure_admin_password        = "vodafonelinux"
    azure_subnet_cidr           = "10.12.11.0/24"
    azure_vnet_cidr             = "10.12.0.0/16"
    azure_private_ip            = "10.12.11.100"
  },
  Vnet3 = {
    azure_resource_group        = "AppProdEu3"
    azure_location              = "North Europe"
    azure_vnet_name             = "AppProdEu3_Vnet"
    azure_subnet_name           = "AppProdEu3_Vnet_subnet"
    azure_instance_name         = "AppProdEu3"
    azure_vm_size               = "Standard_DS1_v2"
    azure_server_key_pair_name  = "Azure_Srv3"
    azure_admin_username        = "vodafonelinux"
    azure_admin_password        = "vodafonelinux"
    azure_subnet_cidr           = "10.13.11.0/24"
    azure_vnet_cidr             = "10.13.0.0/16"
    azure_private_ip            = "10.13.11.100"
  }
}
