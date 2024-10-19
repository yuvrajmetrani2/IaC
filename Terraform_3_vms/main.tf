# providers /provisioners - wrapers to infra APIs

terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = ">=4.51.0"
		}
	}
}

provider "google" {
	project = var.project_id
	credentials = "key.json"
	region = var.region
}
