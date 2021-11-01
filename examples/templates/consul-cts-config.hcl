## Global Config
log_level = "INFO"
port = 8558
license_path = "/opt/consul/bin/consul-ent-license.hclic"
working_dir = "/home/ubuntu"

syslog {}

buffer_period {
  enabled = true
  min = "5s"
  max = "20s"
}

# Consul Block
consul {
  address = "localhost:8500"
}

# Driver "terraform" block
driver "terraform" {
 # version = "0.14.0"
  path = "/home/ubuntu"
  log = false
  persist_log = false

  backend "consul" {
    gzip = true
  }
}

# Task Block
task {
 name        = "learn-cts-example"
 description = "Example task with two services"
 source      = "findkim/print/cts"
 version     = "0.1.0"
 services    = ["web"]
}
