# Google Cloud - Parametrization of Terraform

To make terraform code more generic and maintainable we need to parametrize it.

Here is a simple example we will be building: a Google Cloud Compute Enginer to server a Static Website using Apache Webserver with Terrafrom and parametrization.

We define a file `[variables.tf](http://variables.tf)` that has following content

```
variable "project_id" {
  type        = string
  description = "ID of the Google Project"
}
variable "region" {
  type        = string
  description = "Default Region"
  default     = "us-central1"
}
variable "zone" {
  type        = string
  description = "Default Zone"
  default     = "us-central1-a"
}
variable "server_name" {
  type        = string
  description = "Name of server"
}
variable "machine_type" {
  type        = string
  description = "Machine Type"
  default     = "e2-micro"
}
```

We create `startup.sh` file which contain an script to install the apache webserver in the server

```bash
#! /bin/bash
apt update
apt -y install apache2
```

We create `[provider.tf](http://provider.tf)` as before

```bash
provider "google" {
  project     = "nice-beanbag-402218"
  region      = "us-central1"
  zone        = "us-central1-c"
}
```

We create `[main.tf](http://main.tf)` using variables we defined in `variables.tf`:

```bash
resource "google_compute_instance" "this" {
  name         = var.server_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
        // Ephermal Public IP
    }
  }

  metadata_startup_script = file("startup.sh")
  tags = ["http-server", "https-server"]
}
```

Then we define the `[output.tf](http://output.tf)` file which will output the public IP of the server, so we can view the website using browser and internet:

```bash
output "instance_ip_addr" {
    value = google_compute_instance.this.network_interface.0.access_config.0.nat_ip
}
```

In the last step, we have to give values for the variables that do not have default values. To do this we create `terraform.tfvars` file with following content:

```bash
project_id = "nice-beanbag-402218"
server_name = "parameterizing-terraform-with-apache"
```

## Run Terraform

We run `terraform apply` :

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled.png)

After we type “yes”, Terraform (OpenToFu) starts creating the resources for us:

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%201.png)

Now, let’s copy and paste the `instance_ip_addr` to browser and see the website. I see timeout and probably you will see this timeout too:

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%202.png)

To solve this problem, I realized I need to run the apache service:

```bash
sudo systemctl status apache2
```

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%203.png)

Then it didn’t work. So, I navigated to VPC in the Google Project:

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%204.png)

Especially, I check the **Firewall**

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%205.png)

I see there is no firewall rule to allow http. Therefore, I click on the **Create Firewall Rule**

I create a new Firewall rule named “allow-http” and you can see its details here:

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%206.png)

Now, the website apperas

![Untitled](Google%20Cloud%20-%20Parametrization%20of%20Terraform%20a093f81bcc91492885ef73abed4a711e/Untitled%207.png)

## Reference

This document is based on [https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap01/parameterizing-terraform](https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap01/parameterizing-terraform).