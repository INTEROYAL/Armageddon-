terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = "gcp-cli-testing-b4eced71061d.json"
  project     = "gcp-cli-testing"
  region      = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name          = "task1bucketing1"
  location      = "US"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  uniform_bucket_level_access = false
}

resource "google_storage_bucket_acl" "bucket_acl" {
  bucket         = google_storage_bucket.bucket.name
  predefined_acl = "publicRead"
}


resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.bucket.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}


resource "google_storage_object_acl" "html_acl" {
  for_each       = google_storage_bucket_object.upload_html
  bucket         = google_storage_bucket_object.upload_html[each.key].bucket
  object         = google_storage_bucket_object.upload_html[each.key].name
  predefined_acl = "publicRead"
}


resource "google_storage_bucket_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.png")
  bucket       = google_storage_bucket.bucket.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/png"
}


resource "google_storage_object_acl" "image_acl" {
  for_each       = google_storage_bucket_object.upload_images
  bucket         = google_storage_bucket_object.upload_images[each.key].bucket
  object         = google_storage_bucket_object.upload_images[each.key].name
  predefined_acl = "publicRead"
}

output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/index.html"
}