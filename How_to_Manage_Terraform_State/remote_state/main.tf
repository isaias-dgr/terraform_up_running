data "terraform_remote_state" "db"{
    backend = "s3"

    config = {
      bucket = "terraform-bck-state"
      key = "states/terraform.tfstate"
      region = "us-west-1"
     }
}