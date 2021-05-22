########### Locals ###########
locals {
  name       = random_pet.name.id
  public_key = ""
  region     = "ap-southeast-2"
  region_az  = "ap-southeast-2a"
}

resource "random_pet" "name" {
  length = 1
}
