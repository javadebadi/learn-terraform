#! /bin/bash
# create bucket for backend state


project_id="nice-beanbag-402218"
# since my project name had the word "google" in it, I cannot use it as the name of the bucket
project_name="google-maps-rd"

gcloud services enable storage.googleapis.com
gsutil mb -p $project_id -l us-central1 -b on gs://tf-state-$project_id
gsutil versioning set on gs://tf-state-$project_id
