resource "google_compute_network" "vpc_network1" {
	name = "terraform-network1"
	auto_create_subnetworks = false # true by default
	mtu = 1460 # Maximum transmission unit
}	

resource "google_compute_subnetwork" "subnet1" {
	name = "mysubnet1"
	ip_cidr_range = "10.2.0.0/16"
	region = var.region
	network = google_compute_network.vpc_network1.id
	purpose = "PRIVATE"	
}


resource "google_compute_instance" "gce" {
	count = 3
	name = "my-instance-${count.index}"
	machine_type = "e2-micro"
	zone = var.zone
	
	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-2204-lts"
		}
	}
	
	network_interface {
		subnetwork = google_compute_subnetwork.subnet1.id
		access_config {}
	}
	
	#metadata_startup_script = "echo 'infy@123' | passwd --stdin "
}

resource "google_compute_instance" "ansible-server" {
	name = "ansible-control-server"
	machine_type = "e2-micro"
	zone = var.zone
	
	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-2204-lts"	
		}
	}
	
	network_interface {
		subnetwork = google_compute_subnetwork.subnet1.id
		access_config {}
	}
	
	#metadata_startup_script = "apt-get update -y && apt install ansible -y && echo 'infy@123' | passwd --stdin "
}

resource "google_compute_firewall" "allow-icmp" {
	name = "allow-icmp"
	network = google_compute_network.vpc_network1.id
	
	allow {
		protocol = "icmp"
	}
	
	source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh" {
	name = "allow-ssh"
	network = google_compute_network.vpc_network1.id
	
	allow {
		protocol = "tcp"
		ports = ["22"]
	}
	source_ranges = ["0.0.0.0/0"]
}