# Terraform 101

## Prerequisite

- [Azure cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Git](https://github.com/git-guides/install-git)

## Deploya lokalt

`az login` | loggar in dig på azure

`cd terraform-local` | flyttar dig till rätt directory givet att du står i repo root

\*\*`terraform fmt` | formaterar din terraformkod

`terraform init` | skapar configfiler mm (https://developer.hashicorp.com/terraform/cli/commands/init)

\*\*`terraform validate` | validerar din syntax (https://developer.hashicorp.com/terraform/cli/commands/validate)

`terraform plan` | skapar en excekveringsplan som behövs för att sedan applicera eventuella ändringar(https://developer.hashicorp.com/terraform/cli/commands/plan)

`terraform apply --auto-approve` | deployar

\*\* frivilligt/extra kommando

## Deploya från pipeline

## Known issues

Appliceringen av både keyvault access policy eller RBAC kan ibland ta sådan tid att appliceringen misslyckas.. kör då bara om.

- Update workflow main.yml on row 5 to trigger on push to your branch
