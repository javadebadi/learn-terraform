# Google Cloud Credentials

To create a Google Cloud credentials to use with terraform we need to do a few steps.

## Login to Google Cloud from CLI

First install `gcloud` cli in your computer.

Then run this command:

```bash
gcloud auth login --no-launch-browser
```

The command will give you a link that you should open in the brower and authenticate

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled.png)

Then you have to allow:

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%201.png)

After that you will see another window and in that window you can see a **verification code** for gcloud cli. Copy this verfication code and paste it in to the terminal in which you run the command.

Then you will see this in the terminal:

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%202.png)

## Set the Project

The next is step is to set the project in gcloud

```bash
gcloud config set project "<PROJECT_ID>"
```

Note that you have to give the **Project ID** not the **Project Name**. In this case, I have create a project with name of “google-maps-RD” and the project id is “nice-beanbag-402218”.

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%203.png)

After you set the project, store the project in a variable in the environment

```bash
export GOOGLE_CLOUD_PROJECT=$(gcloud info --format="value(config.project)")
```

To check the value of `GOOGL_CLOUD_PROJECT` is correct, run the following command

```bash
echo $GOOGLE_CLOUD_PROJECT
```

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%204.png)

## Create Service Account for Terraform

Next step is to create a service account for terraform in the Google Cloud 

```bash
gcloud iam service-accounts create terraform \
--description "Terraform Service Account" \
--display-name "terraform"
```

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%205.png)

Then, we store the Email attribute of the created service account in a environment variable in shell:

```bash
export GOOGLE_SERVICE_ACCOUNT=$(gcloud iam service-accounts list --format="value(email)" --filter=name:"terraform@")
```

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%206.png)

Note, that in console, also you can view the created service account for terraform:

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%207.png)

Also do the same to  create `GOOGLE_IMPERSONATE_SERVICE_ACCOUNT` environment variable:

```bash
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(gcloud iam service-accounts list --format="value(email)" --filter=name:"terraform@")
```

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%208.png)

## Permissions for service account

Now, we have to give the necessary permissions to service account to do their project

```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member="serviceAccount:$GOOGLE_SERVICE_ACCOUNT" \
--role="roles/editor"
```

Then

```bash
export USER_ACCOUNT_ID=$(gcloud config get core/account)
```

and then

```bash
gcloud iam service-accounts add-iam-policy-binding \
$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT \
--member="user:$USER_ACCOUNT_ID" \
--role="roles/iam.serviceAccountTokenCreator"
```

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%209.png)

## Create Credential

Next, we creat credentails for application development using this command:

```bash
gcloud auth application-default login --no-launch-browser
```

Then, after authorizing as we did previously, the credentials for Application Default Credentials (ADC) will be created:

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2010.png)

## Test

Create `[provider.tf](http://provider.tf)` file with following content:

```bash
provider "google" {
  project     = "nice-beanbag-402218"
  region      = "us-central1"
  zone        = "us-central1-c"
}
```

You should replace the project by the Project ID of your project.

Now create another file `[main.tf](http://main.tf)` with the following content:

```bash
resource "google_compute_instance" "this" {
  name         = "service-account-impersonation"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

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

Then run `terrafrom init` 

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2011.png)

and the run `terraform apply`

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2012.png)

We see that the action is completed. Now, we can check the Compute Engine in Google Cloud console:

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2013.png)

It is created as we expected.

Now run `terraform destroy`, to destroy all the resources.

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2014.png)

![Untitled](Google%20Cloud%20Credentials%205da7078a78a74b21bca219f293be891d/Untitled%2015.png)

## References

The terraform codes uses in this document are based on this GitHub repo: [https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap01/service-account-impersonation](https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap01/service-account-impersonation)

We have used this repo and Google Cloud documentation to do this task. For the service account creation, Google Cloud has a complete documentation on what are service accounts and how you can use them.