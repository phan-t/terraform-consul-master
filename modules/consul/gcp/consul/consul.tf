// consul admin partitions

resource "consul_admin_partition" "payments" {
  name        = "payments"
  description = "Partition for payments team"
}