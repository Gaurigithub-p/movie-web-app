
terraform {
  backend "s3" {
    bucket = "movie-app-bucket9152"
    key    = "EKS/terraform.tfstate"
    region = "ap-south-1"
  }
}