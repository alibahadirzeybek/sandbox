terraform {
  required_providers {
    docker = {
      source        = "kreuzwerker/docker"
      version       = "3.0.2"
    }

    kubectl = {
      source        = "gavinbunney/kubectl"
      version       = "1.14.0"
    }

    helm    = {
      source        = "hashicorp/helm"
      version       = "2.12.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path     = "~/.kube/config"
  }
}
