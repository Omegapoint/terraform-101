#!/bin/bash
set -eo pipefail

TENANT_ID="30f52344-4663-4c2e-bab3-61bf24ebbed8"

AZURE_AD_APPLICATION_NAME="$1"
SUBSCRIPTION_ID="$2"
ORG_NAME="$3"
REPOSITORY_NAME="$4"

if [[ -z $AZURE_AD_APPLICATION_NAME || -z $SUBSCRIPTION_ID || -z $ORG_NAME || -z $REPOSITORY_NAME ]]
then
	echo "Usage: federated_creds.sh <AZURE_AD_APPLICATION_NAME> <SUBSCRIPTION_ID> <GITHUB_ORG_NAME> <GITHUB_REPOSITORY_NAME>"
	echo ""
	echo "Example: federated_creds.sh myapp 00000000-0000-0000-0000-000000000000 hm-group template-dotnet-api-function-cosmos"
	exit 1
fi

create_ad_app() {
	local app

	app=$(az ad app create --only-show-errors --display-name "$AZURE_AD_APPLICATION_NAME")
	APP_ID=$(echo "$app" | jq -r .appId)
	OBJECT_ID=$(echo "$app" | jq -r .id)
}

create_sp() {
	local assignee_object_id

	assignee_object_id=$(az ad sp create --only-show-errors --id "$APP_ID" | jq -r .id)

	# MSYS_NO_PATHCONV=1 required for it to work on gitbash. https://github.com/Azure/azure-cli/issues/16317

	MSYS_NO_PATHCONV=1 az role assignment create --output none --only-show-errors --role contributor \
		--subscription "$SUBSCRIPTION_ID" \
		--assignee-object-id "$assignee_object_id" \
		--assignee-principal-type ServicePrincipal \
		--scope /subscriptions/"$SUBSCRIPTION_ID"
}

create_federated_cred_json() {
	local name
 	local path

	name="$1"
	path="$2"
	jq -r -c --null-input \
		--arg name "$REPOSITORY_NAME-$name" \
		--arg subject "repo:$ORG_NAME/$REPOSITORY_NAME:$path" \
		'{"name": $name, "issuer":"https://token.actions.githubusercontent.com", "subject":$subject,"description":"","audiences":["api://AzureADTokenExchange"]}'
}

create_federated_cred() {
	local body

	body="$1"
	az rest --output none --only-show-errors --method POST \
		--uri "https://graph.microsoft.com/beta/applications/$OBJECT_ID/federatedIdentityCredentials" \
		--body "$body"
}

echo "Creating Azure AD Application"
create_ad_app

echo "Creating Service Principal"
create_sp

echo "Creating Federated Credentials"
##create_federated_cred "$(create_federated_cred_json pr pull_request)"
##create_federated_cred "$(create_federated_cred_json main-branch ref:refs/heads/main)"
create_federated_cred "$(create_federated_cred_json env-lab environment:lab)" ## FIX ME ## change dev to prod for production federated credentials

echo "Created Azure Credential"
echo ""
jq -r -c --null-input --arg clientId "$APP_ID" --arg tenantId "$TENANT_ID" --arg subscriptionId "$SUBSCRIPTION_ID" '{ "clientId": $clientId, "tenantId": $tenantId, "subscriptionId": $subscriptionId }'

exit 0