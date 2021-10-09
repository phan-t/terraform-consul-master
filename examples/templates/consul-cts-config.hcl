## Global Config
log_level = "INFO"
port = 8558

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
 # path = ""
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

#Service block
service {
 name = "web"
 tag = "cts"
 # namespace = "my-team"
 # datacenter  = "dc1"
 description = "Match only services with a specific tag"
}

