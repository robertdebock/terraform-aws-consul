variable "name" {
  description = "The name of the consul cluster in 3 to 8 characters."
  type        = string
  default     = "consul"
  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 8 && var.name != "default"
    error_message = "Please use a minimum of 3 and a maximum of 8 characters. \"default\" can't be used because it is reserved."
  }
}

variable "consul_version" {
  description = "The version of consul to install."
  type        = string
  default     = "1.10.3"
  validation {
    condition     = can(regex("^1\\.", var.consul_version))
    error_message = "Please use a SemVer version, where the major version is \"1\". Use \"1.9.0\" or newer."
  }
}

variable "consul_datacenter" {
  description = "This flag controls the datacenter in which the agent is running."
  type        = string
  default     = "dc1"
  validation {
    condition     = length(var.consul_datacenter) >= 3 && length(var.consul_datacenter) <= 8
    error_message = "Please use a name with an lenght of 3 to 8 characters."
  }
}

variable "key_filename" {
  description = "The name of the file that has the public ssh key stored."
  default     = "id_rsa.pub"
}

variable "region" {
  description = "The region to deploy to."
  type        = string
  default     = "eu-central-1"
  validation {
    condition     = contains(["eu-central-1", "eu-north-1", "eu-south-1", "eu-west-1", "eu-west-2", "eu-west-3", ], var.region)
    error_message = "Please use \"eu-central-1\", \"eu-north-1\", \"eu-south-1\", \"eu-west-1\", \"eu-west-2\" or \"eu-west-3\"."
  }
}

variable "size" {
  description = "The size of the deployment."
  type        = string
  default     = "small"
  validation {
    condition     = contains(["development", "minimum", "small", "large", "maximum"], var.size)
    error_message = "Please use \"development\", \"minimum\", \"small\", \"large\" or \"maximum\"."
  }
}

variable "amount" {
  description = "The amount of instances to deploy."
  type        = number
  default     = 5
  validation {
    condition     = var.amount % 2 == 1 && var.amount >= 3 && var.amount <= 5
    error_message = "Please use an odd number for amount, like 3 or 5."
  }
}

variable "vpc_id" {
  description = "The VPC identifier to deploy in. Fill this value when you want the consul installation to be done in an existing VPC."
  type        = string
  default     = ""
}

variable "bastion_host" {
  description = "A bastion host is optional and would allow you to login to the instances."
  type        = bool
  default     = true
}

variable "aws_vpc_cidr_block_start" {
  description = "The first two octets of the VPC cidr. Only required when `vpc_id` is set to \"\"."
  type        = string
  default     = "172.16"
}

variable "tags" {
  description = "Tags to add to resources."
  type        = map(string)
  default = {
    owner = "unset"
  }
}

variable "max_instance_lifetime" {
  description = "The amount of seconds after which to replace the instances."
  type        = number
  default     = 86400
  validation {
    condition     = var.max_instance_lifetime == 0 || (var.max_instance_lifetime >= 86400 && var.max_instance_lifetime <= 31536000)
    error_message = "Use \"0\" to remove the parameter or a value between \"86400\" and \"31536000\"."
  }
}

variable "service_cidr_blocks" {
  description = "A list of CIDR blocks to allow access to Consul."
  type        = list(string)
  default     = ["0.0.0.0/0"]
  validation {
    condition     = length(var.service_cidr_blocks) >= 1
    error_message = "Please specify a list of CIDRs. For example: [\"172.0.0.0/8\", \"10.0.0.0/8\"]."
  }
}
