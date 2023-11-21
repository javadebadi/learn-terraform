# Terraform

## Table of Contents
[Terraform Installation](01-Installation.md)
[Terraform to Provision the Google Cloud](terraform-google-cloud/index.md)


## Terraform Commands
- `terraform init` to initialize
- `terraform plan --out=plan` to view and create a Terraform plan
- `terraform apply plan` to actually provision the resources in the created plan
- `terraform destroy` to remove all resources”
- `terraform state list` lists all resources in terraform state
- `terraform state show <object-address>` shows details of the state of the given address (which corresponds to an object)
- `terraform console` interactive console to explore terraform state and find out more about attributes of resources
- `terraform refresh` updates terraform state with latest metadata in the cloud provider
- `terraform taint <object-address>` marks a terraform resource to remove and rebuild next time it runs


## Terraform State
Terraform is a declarative IaC tools. You determine the desired **State** and Terraform will figure out how to reach that desired **State**.
When Terraform is used locally, it will store the state in a file named `terraform.tfstate`. If there is a team working on a project, Terraform state should be stored in a bucket (Google Storage or Amazon S3). In Terraform this is related to **state backend**. Terraform support transaction operation by locking the bucket when a transaction (a Terraform run) is not completed.

The bucket for a Terraform project should be created manually (without Terraform) and the convention for bucket name is `<project-name>-tf-state`. Also the bucket versioning can be enabled to make rollback possible.

To change the backend state of the terraform (for example from `local` to `gcs`) run: `terraform init -migrate-state` after changing the `backend.tf` file content.


## Terraform Identification of Resources

Terraform uses **Addresses** to determine objects in its state. The address is a unique way to address an object in Terraform.
Terraform uses `resource_type.resource_name` to identify each resource uniquely resources.
If a resources is actually list of instances (not just a single instance), then Terraform uses `resource_type.resource_name.instance_index` to uniquely determine an instance of a resource.

Once Terraform is used to manage resource in AWS or Google Cloud, then we should not use console, CLI or SDK to manage resources related to a Terraform created resources.