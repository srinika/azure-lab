terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "Azure-Lab"

        workspaces {
            name = "azure-lab-dev"
        }
    }
}