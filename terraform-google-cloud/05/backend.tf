terraform {
  backend "gcs" {
    bucket = "tf-state-nice-beanbag-402218"
    prefix = "backend-state"
  }
}