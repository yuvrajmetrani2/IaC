output "instance_ip"  {
	value = [for instance in google_compute_instance.gce : instance.network_interface[0].access_config[0].nat_ip]
	description = "public ip address"
}

output "success" {
	value = "the infrastructure provisioning is complete"
	description = "success message"
}

output "server_ip" {
	value = google_compute_instance.ansible-server.network_interface[0].access_config[0].nat_ip
	description = "ansiblle-server-ip"
}