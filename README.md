# Terraform 101

## Prerequisite  

* [Azure cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Git](https://github.com/git-guides/install-git)

## Deploya lokalt

## Deploya från pipeline

1. Skapa en branch från main med ett unik namn

```bash
git checkout -b name-of-your-branch
```

2. Öppna filen **.github/workflows/main.yml**
3. Ändra environment variblerna, . **Välj något unik som du kommer ihåg!** 

```bash
######## Resources for saving tfstate
  RESOURCE_GROUP_TFSTATE: name-of-your-resource-group-containing-tfstate
  STORAGE_ACCOUNT_TFSTATE: name-of-your-storage-account-containing-tfstate ##Can only be lower case letter and numbers
  CONTAINER_TFSTATE: name-of-your-container-containing-tfstate
  BLOB_TFSTATE: name-of-your-blob-containing-tfstate

######## TF_VAR_ specific naming is needed for variables used in Terraform files
  TF_VAR_project: name-of-your-resource-group-containing-resources-deployed-using-terraform
  TF_VAR_secret_value: your-super-secret-value
  TF_VAR_location: northeurope ##Does not need to be changed
````

4. Ändra så workflowt triggas på din branch iställt för main

````bash
on:
  push:
    branches: [main]
```

5. Pusha dina ändringar till din branch.

````bash
git add .
git commit -m "commit-message"
git push --set-upstream origin name-of-your-branch
```

6. Gå till GitHub, kolla under taben **Actions**. Ett workflow ska ha triggats med ditt commit-meddelande. Klicka på körningen och kolla så att build-and-deploy jobbet går igenom.  