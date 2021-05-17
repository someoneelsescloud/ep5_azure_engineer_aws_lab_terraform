########### Locals ###########
locals {
  name       = random_pet.name.id
  locationid = random_shuffle.locations.result
  public_key = ""
  region     = "ap-southeast-2"
  region_az  = "ap-southeast-2a"
}

resource "random_pet" "name" {
  length = 1
}

resource "random_shuffle" "locations" {
  input        = ["eastus", "westus"]
  result_count = 2
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_id" "prefix" {
  byte_length = 8
}