  provider "google" {
  project = "potent-bloom-377613"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_storage_bucket" "static" {
 project       = "potent-bloom-377613"
 name          = "kubelek_ewy_ch"
 location      = "US"
 storage_class = "STANDARD"

uniform_bucket_level_access = false

}
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.static.id
  role   = "READER"
  entity = "allUsers"

}

resource "google_compute_instance" "dare-id-vm" {
  name         = "dareit-ewa-ch-vm-tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
        tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "dareit"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "users" {
  name     = "dareit_user"
  instance = google_sql_database_instance.main.name
   password = "changemechanged"
}

