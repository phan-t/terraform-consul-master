terraform {
  required_providers {
    kubernetes = {
    }
    consul = {
      configuration_aliases = [ consul.aws, consul.gcp ]
    }
  }
}