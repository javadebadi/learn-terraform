# Google Cloud - Terraform Backend State

We can use Google Stroage or Amazon S3 to store state of a Terraform instead of locally storign the state file.

In order to this you have to create a bucker manually. We have a script `[setup.sh](http://setup.sh)` that uses Google Cloud CLI to create the bucket for our project

```bash
#! /bin/bash
# create bucket for backend state

project_id="nice-beanbag-402218"
# since my project name had the word "google" in it, I cannot use it as the name of the bucket
project_name="google-maps-rd"

gcloud services enable storage.googleapis.com
gsutil mb -p $project_id -l us-central1 -b on gs://tf-state-$project_id
gsutil versioning set on gs://tf-state-$project_id
```

We should tell Terraform to use this bucket to store the state.

We have all files from previous section, but now we create another file `[backend.tf](http://backend.tf)` as follows:

```
terraform {
  backend "gcs" {
    bucket = "tf-state-nice-beanbag-402218"
    prefix = "backend-state"
  }
}
```

After running `terrafrom apply` we can see that a new object in the `tf-state-nice-beanbag-402218` bucket is beign created.

![Untitled](Google%20Cloud%20-%20Terraform%20Backend%20State%204cee75da8d1c40d6b22b4720d7f03555/Untitled.png)

## Reference

[https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap02/backend](https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide/tree/main/chap02/backend)