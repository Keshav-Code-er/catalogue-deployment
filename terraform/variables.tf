variable "project-name" {
  default = "roboshop-shop"
}

variable "env" {
  default = "dev"
}



variable "common_tags" {
  default = {
    Project     = "roboshop-shop"
    component   = "catalogue"
    Environment = "DEV"
    terraform   = "true"
  }
}

variable "domain_name" {
  default = "joindevops.shop"
  
}

variable "app_version" {
  # this is just to test variables is flowing from terraform to shell and then to ansible
  default = "10.3.0"

}