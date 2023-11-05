# Installation

## Installing the Open Source Terraform (OpenToFu)
To install terraform, run the following command:
```bash
brew install opentofu
```
and then check the version to check the installation:
```bash
tofu --version
```
![Check OpenToFu version](images/tofu-version.png)

You can also edit `~/.zprofile`  or `~/.bashrc` to create `terraform` alias:
```
alias terraform=`tofu`
```