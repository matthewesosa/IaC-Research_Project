variable "project_name" {}

variable "ami_id" {
  default = "ami-0fb820135757d28fd"
  }

variable "instance_type" {
  default = "t3.medium"
}

variable "priv_sub_3a_id" {}
variable "priv_sub_4b_id" {}

variable "webserver_sg_id" {}
variable "max_size" {
    default = 6
}
variable "min_size" {
    default = 2
}

variable "targetgroup_arn" {}
