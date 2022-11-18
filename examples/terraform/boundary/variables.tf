// HashiCorp Boundary variables

variable "init_user" {
  description = "Initial admin user"
  type        = string
  default     = "admin"
}

variable "init_pass" {
  description = "Initial admin user password"
  type        = string
  default     = "HashiCorp1!"
}

variable "boundary_config" {
  description = "Boundary configuration"
  type        = map
  default     = {
    avobank = {
      description = "Avocado Bank"
      projects = {
        insurance  = {
          name        = "Insurance"
          auth_method = ""
        }
        onlinebank  = {
          name        = "Online Banking"
          auth_method = ""
        }
        trading  = {
          name        = "Trading"
          auth_method = ""
        }
      }
    }
  }  
}