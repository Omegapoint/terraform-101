# Terraform 101

## Prerequisite

- [Azure cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Git](https://github.com/git-guides/install-git)

## Deploya lokalt

1. Logga in på azure via cli

```bash
az login
```

2. Ta dig till terraform-local mappen

```bash
cd terraform-local
```

3.  validerar din syntax och formaterar https://developer.hashicorp.com/terraform/cli/commands/validate

```bash
terraform fmt
terraform validate
```

4. Uppdatera resursgruppsnamnet i terraform-local/variables.tf filen och verifiera igen med övre commandon (kommer ge fel, men att det är dags att gå vidare till nästa steg)

5. Initializera terraform och validera, kommer skapa configfiler mm, se https://developer.hashicorp.com/terraform/cli/commands/init

```bash
terraform init
terraform validate
```

6. Skapa en excekveringsplan som behövs för att sedan applicera eventuella ändringar på tidigare state https://developer.hashicorp.com/terraform/cli/commands/plan

```bash
terraform plan
```

7. Applicera ändringarna (aka deploya). kräver manuellt ok steg om du inte lägger till --auto-approve
7.1. Funkar det inte? kolla vad som har lyckats deployats. Kör `terraform apply` igen, se skillnaden på loggarna och fråga kompetenspassansvarig varför det inte funkade första gången

```bash
terraform apply
```

8. Inspektera resursgruppen du skapat

9. Inspektera statet du skapat lokalt

10. Testa att ändra något och applicera ändringarna

## Deploya från pipeline

1. Skapa en branch från main med ett unik namn

```bash
git checkout -b name-of-your-branch
```

2. Öppna filen **.github/workflows/main.yml**
3. Ändra environment variblerna. **Välj något unik som du kommer ihåg!**

```bash
######## Resources for saving tfstate
  RESOURCE_GROUP_TFSTATE: name-of-your-resource-group-containing-tfstate
  STORAGE_ACCOUNT_TFSTATE: name-of-your-storage-account-containing-tfstate ##Can only be lower case letter and numbers
  CONTAINER_TFSTATE: name-of-your-container-containing-tfstate
  BLOB_TFSTATE: name-of-your-blob-containing-tfstate

######## TF_VAR_ specific naming is needed for variables used in Terraform files
  TF_VAR_project: name-of-your-resource-group-containing-resources-deployed-using-terraform ##Can only be letters, numbers, dashes, 3-21 chars
  TF_VAR_secret_value: your-super-secret-value
  TF_VAR_location: northeurope ##Does not need to be changed
```

4. Ändra så workflowt triggas på din branch iställt för main

```bash
on:
  push:
    branches: [main]
```

5. Gå till [Azure](https://portal.azure.com/#home)

6. Gå in på Azure Active Directory (du kan söka i sökfältet)

7. Sök efter dig själv och kopiera ditt **Object ID**

8. Klistra in ditt Object ID som en string i **terraform/main.tf** på rad 55. - Detta gör så att du får en roll i key vaultet och kan se, modifiera och ta bort din secret. Du kan även lägga upp nya secrets.

9. Pusha dina ändringar till din branch.

```bash
git add -A
git commit -m "commit-message"
git push --set-upstream origin name-of-your-branch
```

10. Gå till GitHub, kolla under taben **Actions**. Ett workflow ska ha triggats med ditt commit-meddelande. Klicka på körningen och kolla så att build-and-deploy jobbet går igenom. (Om körningen inte går igenom pga. "If role assignments, deny assignments or role definitions were changed recently, please observe propagation time" kör om workflowt)

11. Gå till din resursgrupp i Azure och kolla så det finns ett key vault med din secret där.

12. Gå till resursgruppen som innehåller ditt tfstate. Klicka på storage accounten, sen containers. Ladda ner din blob och inspektera tfstatet. Hittar du något intressant?

13. Ta bort dina resursgrupper om du inte vill fortsätta labba. Om du inte har permissions att plocka bort något, säg till så fixar vi!

## Known issues

Appliceringen av både keyvault access policy eller RBAC kan ibland ta sådan tid att appliceringen misslyckas.. kör då bara om.
