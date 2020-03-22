provider "aws" {
  region = "us-east-1"
}

module "aws-vpc" {
  source = "../../../modules/services/vpc"

}
