# Google Cloud

First step is to create a separate project.

In the [https://console.cloud.google.com](https://console.cloud.google.com) open a cloud shell by clicking in this button:

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled.png)

The a cloud shell will appera for you in the screen

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%201.png)

By default Terraform is installed and is available for you in the shell.

To check ther version of the Terraform write

```bash
terraform --version
```

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%202.png)

To create virtual machines in our google cloud (Compute Engines) we need to enable compute API. To do this run the following command:

```bash
gcloud services enable compute.googleapis.com
```

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%203.png)

Then you will see 

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%204.png)

Also, you can navigate to APIs & SERVICES → Library and search for Compute Engine API then you will see that

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%205.png)

There is a “MANAGE” button. It means that API is enabled successfully.

Now, let’s provision our first compute engine in GCP using terraform

In the `[main.tf](http://main.tf)` file write this:

```json
resource "google_compute_instance" "this" {
  name         = "cloudshell"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
  }
}
```

Now, first run this:

```json
terraform init
```

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%206.png)

and then

```json
terraform apply
```

after this terraform will show us the actions it will take. We write yes to approve the changes

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%207.png)

Then we will see this

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%208.png)

Now, we can go the google cloud console and explore compute engine to see that instance that is created for us:

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%209.png)

To destroy resource using terraform you run

```json
terraform destroy
```

![Untitled](Google%20Cloud%208f16fb098e8a4d64aaaa9eba07278349/Untitled%2010.png)