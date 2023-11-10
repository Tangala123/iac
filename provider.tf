provider "aws" {
  region = var.location
}

/*terraform {
  backend "s3" {
    bucket = "jhc-bucket"
    key = "terraform-tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-state-table"
  }
}
*/