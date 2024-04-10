variable "prosimo_teamName" {
  type = string
}
variable "prosimo_token" {
  type = string
}


variable "region" {
  type = string
}


variable "connectType" {
  type = string
}

variable "vpc" {
  type = string
}

variable "connectivity_type" {
  type = string
}

variable "placement" {
  type = string
}

variable "cloud" {
  type = string
}

variable "cloudNickname" {
  type = string
}


variable "decommission" {
  type = bool
}

variable "onboard" {
  type = bool
}

variable "cloud_type" {
  type = string
}

variable "network_name" {
  type        = string
  description = "Name of the Prosimo Network"

}

variable "network_namespace" {
  type        = string
  description = "Name of the Prosimo Namespace to on-board network into"

}




variable "tgw_id" {
  description = "TGW ID"
  default = ""
}

#variable "subnets" {
#  description = "Subnet ID"
#  default = ""
#}

variable "subnets_config" {
  type = list(object({
    subnet         = string
    virtual_subnet = optional(string)  # Make virtual_subnet optional
  }))
  default = []
}